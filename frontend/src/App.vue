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
            <v-card-title>{{account.name}} Account - ${{account.balance}}</v-card-title>
            <v-list>
              <v-list-item-group>
                <v-list-item
                  v-for="transaction in account.transactions"
                  :key="transaction.id"
                >
                  <v-list-item-content>
                    <v-list-item-subtitle class="primary--text pb-1">{{transaction.createdAt}}</v-list-item-subtitle>
                    <v-list-item-title class="d-flex">
                      {{transaction.description}}
                      <v-spacer></v-spacer>
                      ${{transaction.amount}}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <v-card-actions>
              <v-form>
                <v-row class="pa-2">
                  <v-col cols="7">
                    <v-text-field
                      placeholder="Enter description"
                      outlined
                      dense
                      hide-details
                    ></v-text-field>
                  </v-col>
                  <v-col cols="5" class="pl-1">
                    <v-text-field
                      placeholder="0.00"
                      outlined
                      dense
                      hide-details
                      prepend-inner-icon="mdi-currency-usd"
                      append-outer-icon="mdi-send"
                      @click:append-outer="createTransaction(account.id)"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-form>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
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
            createdAt
          }
        }
      }
    `
  },
  data: () => ({
    //
  }),
  methods: {
    createTransaction(accountId) {
      console.log(accountId)
    }
  }
}
</script>
