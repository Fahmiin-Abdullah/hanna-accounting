<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      Hanna Accounting Software - Accounting simplified
      <v-spacer></v-spacer>
      <v-btn
        color="success"
        small
        depressed
        @click="dialog = true;"
      >
        <v-icon
          small
          class="pr-2"
        >mdi-plus</v-icon>
        Add new transaction
      </v-btn>
    </v-app-bar>

    <v-main class="ma-5">
      <v-row>
        <v-col v-for="account in accounts" :key="account.id" cols="4">
          <v-card>
            <v-card-title>{{ account.name }} Acc. - ${{ account.balance }}</v-card-title>

            <hr>

            <v-list flat>
              <p class="mb-0 pl-4 font-weight-bold">Credit</p>
              <v-list-item-group>
                <v-list-item
                  v-for="transaction in account.creditTransactions"
                  :key="transaction.id"
                  @click="editTransaction(transaction)"
                >
                  <v-list-item-content>
                    <v-list-item-subtitle class="primary--text pb-1">{{ transaction.createdAt }}</v-list-item-subtitle>
                    <p class="d-flex mb-0">
                      {{ transaction.description }}
                      <v-spacer></v-spacer>
                      ${{ transaction.amount }}
                    </p>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>

              <hr>

              <p class="mb-0 pl-4 font-weight-bold pt-3">Debit</p>
              <v-list-item-group>
                <v-list-item
                  v-for="transaction in account.debitTransactions"
                  :key="transaction.id"
                  @click="editTransaction(transaction)"
                >
                  <v-list-item-content>
                    <v-list-item-subtitle class="primary--text pb-1">{{ transaction.createdAt }}</v-list-item-subtitle>
                    <p class="d-flex mb-0">
                      {{ transaction.description }}
                      <v-spacer></v-spacer>
                      ${{ transaction.amount }}
                    </p>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-card>
        </v-col>
      </v-row>

      <v-dialog
        v-model="dialog"
        width="500"
      >
        <v-card>
          <v-card-title>
            <template v-if="localTransaction.id">
              Edit/Delete Transaction {{ localTransaction.id }}
            </template>
            <template v-else>
              Add New Transaction
            </template>
            <v-spacer></v-spacer>
            <v-btn
              icon
              small
              @click="dialog = false; clearLocalTransaction();"
            >
              <v-icon>
                mdi-close
              </v-icon>
            </v-btn>
          </v-card-title>
          <v-form>
            <v-card-text>
              <v-text-field
                v-model="localTransaction.description"
                placeholder="Enter description"
                outlined
                dense
                hide-details
              ></v-text-field>
            </v-card-text>
            <v-card-text v-if="!localTransaction.id">
              <v-select
                v-model="localTransaction.fromAccountId"
                :items="accounts.filter(acc => acc.id != localTransaction.toAccountId)"
                item-value="id"
                item-text="name"
                placeholder="Account to be debited from"
                outlined
                dense
                hide-details
              ></v-select>
            </v-card-text>
            <v-card-text v-if="!localTransaction.id">
              <v-select
                v-model="localTransaction.toAccountId"
                :items="accounts.filter(acc => acc.id != localTransaction.fromAccountId)"
                item-value="id"
                item-text="name"
                placeholder="Account to be credited to"
                outlined
                dense
                hide-details
              ></v-select>
            </v-card-text>
            <v-card-text>
              <v-text-field
                v-model="localTransaction.amount"
                placeholder="0.00"
                outlined
                dense
                hide-details
                prepend-inner-icon="mdi-currency-usd"
              ></v-text-field>
            </v-card-text>
          </v-form>
          <v-card-actions v-if="localTransaction.id">
            <v-col class="pl-0">
              <v-btn
                color="error"
                block
                depressed
                @click="deleteTransaction(localTransaction.id)"
              >
                Delete
              </v-btn>
            </v-col>
            <v-col class="pr-0">
              <v-btn
                color="success"
                block
                depressed
                @click="updateTransaction(localTransaction.id)"
              >
                Update
              </v-btn>
            </v-col>
          </v-card-actions>
          <v-card-actions v-else>
            <v-btn
              color="success"
              block
              depressed
              @click="createTransaction()"
            >
              Save
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-main>
  </v-app>
</template>

<script>
import gql from 'graphql-tag'

export default {
  name: 'App',
  apollo: {
    accounts: gql `
      {
        accounts {
          id
          name
          balance
          creditTransactions {
            id
            description
            amount
            fromAccountId
            toAccountId
            createdAt
          }
          debitTransactions {
            id
            description
            amount
            fromAccountId
            toAccountId
            createdAt
          }
        }
      }
    `
  },
  data: () => ({
    description: '',
    amount: null,
    fromAccountId: null,
    toAccountId: null,
    localTransaction: {
      id: null,
      description: '',
      fromAccountId: null,
      toAccountId: null,
      amount: null
    },
    dialog: false
  }),
  methods: {
    async createTransaction() {
      await this.$apollo.mutate({
        mutation: gql `
          mutation($description: String!, $amount: String!, $fromAccountId: ID!, $toAccountId: ID!) {
            createTransaction(input: {
              description: $description,
              amount: $amount,
              fromAccountId: $fromAccountId,
              toAccountId: $toAccountId,
            }) {
              transaction {
                id
                description
                fromAccountId
                toAccountId
                amount
              }
              errors
            }
          }
        `,
        variables: {
          description: this.localTransaction.description,
          fromAccountId: this.localTransaction.fromAccountId,
          toAccountId: this.localTransaction.toAccountId,
          amount: this.localTransaction.amount
        }
      }).then(data => {
        this.dialog = false
        this.clearLocalTransaction()
        if (data) this.$apollo.queries.accounts.refetch()
      }).catch(error => {
        console.log(error)
      })
    },
    editTransaction(transaction) {
      this.localTransaction = transaction
      this.dialog = true
    },
    async updateTransaction() {
      await this.$apollo.mutate({
        mutation: gql `
          mutation($id: ID!, $description: String!, $amount: String!, $fromAccountId: ID!, $toAccountId: ID!) {
            updateTransaction(input: {
              id: $id,
              description: $description,
              amount: $amount,
              fromAccountId: $fromAccountId,
              toAccountId: $toAccountId
            }) {
              transaction {
                id
                description
                fromAccountId
                toAccountId
                amount
              }
              errors
            }
          }
        `,
        variables: {
          id: this.localTransaction.id,
          description: this.localTransaction.description,
          fromAccountId: this.localTransaction.fromAccountId,
          toAccountId: this.localTransaction.toAccountId,
          amount: this.localTransaction.amount
        }
      }).then(data => {
        if (data) {
          this.$apollo.queries.accounts.refetch()
          this.dialog = false
        }
      }).catch(error => {
        console.log(error)
      })
    },
    async deleteTransaction() {
      await this.$apollo.mutate({
        mutation: gql `
          mutation($id: ID!) {
            deleteTransaction(input: {
              id: $id
            }) {
              transaction {
                id
                description
                fromAccountId
                toAccountId
                amount
              }
              errors
            }
          }
        `,
        variables: {
          id: this.localTransaction.id
        }
      }).then(data => {
        if (data) {
          this.$apollo.queries.accounts.refetch()
          this.dialog = false
        }
      }).catch(error => {
        console.log(error)
      })
    },
    clearLocalTransaction() {
      this.localTransaction = {
        id: null,
        description: '',
        fromAccountId: null,
        toAccountId: null,
        amount: null
      }
    }
  }
}
</script>
