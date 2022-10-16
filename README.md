# Hanna Accouting Software - Accounting simplified

This is a simple debit and credit account tracker for transactions built with Rails GraphQL API and a Vue.js frontend.

## Scope of work

It's a simple bare bones product development of digitilizing accounting. It has two accounts, one for debit and one for credit. The user can add, update or deelte transactions in the two accounts and the balance is calculated. User stories are like so:

1. As a user, I can view accounts and the transactions within those accounts
2. As a user, I can view the balances of these accounts
3. As a user, I can add, update or delete transactions

The most interesting part of this project is making use of GraphQL as it's a new technology for me but certainly an interestring one relative to normal REST queries.

Assumptions on the project requirement includes the functionalities of this MVP - I've implemented a bare bones version of it as specified in the requirements rather than going into the nitty gritty of how accounting actually works in real life. That's a separate fascination to dive into.

## Project setup

API:
1. Clone this repo
2. Run `bundle`
3. Run `rails db:setup`
4. Run `rails s -p 3000`
5. Runs `rails db:seed` for creating the Debit and Credit account + a few transactions to start off with
6. You can play around with the graphql API by visiting `http://localhost:3000/graphiql`

Frontend:

Pre-requisite is to complete steps above for setting up API and running it locally

1. CD into `frontend` folder
2. Run `npm i`
3. Run `npm run serve`
4. Make sure that the API is running locally on port `3000`

## What can be improved?

Due to the time constraint as I have only a limited time to work on this project, here are a few things that I would improve on

1. Better error handling - right now we're only console logging the error message
2. Adding unit tests to the API - RSpec tests is my go to
3. Stricter validations on FE and BE on inputs
4. Extracting some variables into an `env` file like API url
5. Whitelisting only certain URLs to allow communication with the API (important for prod)
