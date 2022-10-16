<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      Hanna Accounting Software - Accounting simplified
    </v-app-bar>

    <v-main class="ma-5">
      <v-row>
        <v-col v-for="account in accounts" :key="account.id">
          <v-card>
            <v-card-title>{{ account.name }} Account - ${{ account.balance }}</v-card-title>
            <v-list>
              <v-list-item-group>
                <v-list-item
                  v-for="transaction in account.transactions"
                  :key="transaction.id"
                  @click="editTransaction(transaction)"
                >
                  <v-list-item-content>
                    <v-list-item-subtitle class="primary--text pb-1">{{ transaction.createdAt }}</v-list-item-subtitle>
                    <v-list-item-title class="d-flex">
                      {{ transaction.description }}
                      <v-spacer></v-spacer>
                      ${{ transaction.amount }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <v-card-actions>
              <v-form>
                <v-row class="pa-2">
                  <v-col cols="7">
                    <template v-if="account.id == 1">
                      <v-text-field
                        v-model="debitDescription"
                        placeholder="Enter description"
                        outlined
                        dense
                        hide-details
                      ></v-text-field>
                    </template>
                    <template v-else>
                      <v-text-field
                        v-model="creditDescription"
                        placeholder="Enter description"
                        outlined
                        dense
                        hide-details
                      ></v-text-field>
                    </template>
                  </v-col>
                  <v-col cols="5" class="pl-1">
                    <template v-if="account.id == 1">
                      <v-text-field
                        v-model="debitAmount"
                        placeholder="0.00"
                        outlined
                        dense
                        hide-details
                        prepend-inner-icon="mdi-currency-usd"
                        append-outer-icon="mdi-plus-circle-outline"
                        @click:append-outer="createTransaction(account.id)"
                      ></v-text-field>
                    </template>
                    <template v-else>
                      <v-text-field
                        v-model="creditAmount"
                        placeholder="0.00"
                        type="number"
                        outlined
                        dense
                        hide-details
                        prepend-inner-icon="mdi-currency-usd"
                        append-outer-icon="mdi-plus-circle-outline"
                        @click:append-outer="createTransaction(account.id)"
                      ></v-text-field>
                    </template>
                  </v-col>
                </v-row>
              </v-form>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>

      <v-dialog
        v-model="dialog"
        width="500"
      >
        <v-card>
          <v-card-title>
            Edit/Delete Transaction {{ targetTransaction.id }}
            <v-spacer></v-spacer>
            <v-btn
              icon
              small
              @click="dialog = false; targetTransaction = { id: null, description: '', amount: null }"
            >
              <v-icon>
                mdi-close
              </v-icon>
            </v-btn>
          </v-card-title>
          <v-form>
            <v-card-text>
              <v-text-field
                v-model="targetTransaction.description"
                placeholder="Enter description"
                outlined
                dense
                hide-details
              ></v-text-field>
            </v-card-text>
            <v-card-text>
              <v-text-field
                v-model="targetTransaction.amount"
                placeholder="0.00"
                outlined
                dense
                hide-details
                prepend-inner-icon="mdi-currency-usd"
              ></v-text-field>
            </v-card-text>
          </v-form>
          <v-card-actions>
            <v-col class="pl-0">
              <v-btn
                color="error"
                block
                depressed
                @click="deleteTransaction(targetTransaction.id)"
              >
                Delete
              </v-btn>
            </v-col>
            <v-col class="pr-0">
              <v-btn
                color="success"
                block
                depressed
                @click="updateTransaction(targetTransaction.id)"
              >
                Update
              </v-btn>
            </v-col>
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
          transactions {
            id
            description
            amount
            accountId
            createdAt
          }
        }
      }
    `
  },
  data: () => ({
    debitDescription: '',
    creditDescription: '',
    debitAmount: null,
    creditAmount: null,
    targetTransaction: {
      id: null,
      description: '',
      amount: null
    },
    dialog: false
  }),
  methods: {
    async createTransaction(accountId) {
      await this.$apollo.mutate({
        mutation: gql `
          mutation($description: String!, $amount: String!, $accountId: ID!) {
            createTransaction(input: {
              description: $description,
              amount: $amount,
              accountId: $accountId
            }) {
              transaction {
                id
                description
                amount
              }
              errors
            }
          }
        `,
        variables: {
          description: accountId == 1 ? this.debitDescription : this.creditDescription,
          amount: accountId == 1 ? this.debitAmount : this.creditAmount,
          accountId: accountId
        }
      }).then(data => {
        if (data) this.$apollo.queries.accounts.refetch()
      }).catch(error => {
        console.log(error)
      })
    },
    editTransaction(transaction) {
      this.targetTransaction = transaction
      this.dialog = true
    },
    async updateTransaction() {
      await this.$apollo.mutate({
        mutation: gql `
          mutation($id: ID!, $description: String!, $amount: String!, $accountId: ID!) {
            updateTransaction(input: {
              id: $id,
              description: $description,
              amount: $amount,
              accountId: $accountId
            }) {
              transaction {
                id
                description
                amount
              }
              errors
            }
          }
        `,
        variables: {
          id: this.targetTransaction.id,
          description: this.targetTransaction.description,
          amount: this.targetTransaction.amount,
          accountId: this.targetTransaction.accountId
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
                amount
              }
              errors
            }
          }
        `,
        variables: {
          id: this.targetTransaction.id
        }
      }).then(data => {
        if (data) {
          this.$apollo.queries.accounts.refetch()
          this.dialog = false
        }
      }).catch(error => {
        console.log(error)
      })
    }
  }
}
</script>
