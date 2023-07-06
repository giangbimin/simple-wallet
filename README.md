# Internal Wallet Transactional System API

## Table of Contents

- [Internal Wallet Transactional System API](#internal-wallet-transactional-system-api)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Requirements](#requirements)
    - [Task 1: Architect generic wallet solution](#task-1-architect-generic-wallet-solution)
    - [Task 2: Create model relationships and validations](#task-2-create-model-relationships-and-validations)
    - [Task 3: Use STI or other design pattern for money manipulation](#task-3-use-sti-or-other-design-pattern-for-money-manipulation)
    - [Task 4: Implement custom sign-in (session solution)](#task-4-implement-custom-sign-in-session-solution)
    - [Task 5: Create LatestStockPrice library (using RapidAPI)](#task-5-create-lateststockprice-library-using-rapidapi)
  - [Installation](#installation)
  - [Project Structure](#project-structure)
  - [Configuration](#configuration)
  - [Database Setup](#database-setup)
  - [Models and Relationships](#models-and-relationships)
  - [Wallet System](#wallet-system)
  - [API Endpoints](#api-endpoints)
  - [Custom Sign-In](#custom-sign-in)
  - [LatestStockPrice Library](#lateststockprice-library)
  - [Testing](#testing)

## Description

This is an API for managing internal wallets and performing money manipulation operations between entities (e.g., User, Stock, Team). The API allows you to create transactions, check wallet balances, and perform various financial operations securely.

## Requirements

### Task 1: Architect generic wallet solution

Identify the common attributes and behaviors required for a wallet entity (e.g., User, Stock, Team).
Design the database schema to accommodate wallets, transactions, and their relationships.
Determine how money manipulation operations (e.g., deposit, withdrawal) will be performed on the wallets.

### Task 2: Create model relationships and validations

Define the model relationships between entities (User, Stock, Team) and wallets.
Set up the necessary associations, such as a user having one wallet and a wallet having many transactions.
Add validations to the models to ensure data integrity, such as validating required fields and the presence of source and target wallets for each transaction.

### Task 3: Use STI or other design pattern for money manipulation

Consider using Single Table Inheritance (STI) or another suitable design pattern to handle money manipulation operations across different entities.
Implement a shared base class (e.g., Wallet) and derive entity-specific wallet classes (e.g., UserWallet, StockWallet) to encapsulate entity-specific behavior.

### Task 4: Implement custom sign-in (session solution)

Create the necessary controllers and routes to handle sign-in functionality.
Implement a secure sign-in mechanism without relying on external gems, such as using encrypted passwords and session management techniques.
Validate user credentials and authenticate the user to generate and manage a session.

### Task 5: Create LatestStockPrice library (using RapidAPI)

Create a new library in the lib folder of your Rails project to encapsulate the functionality for retrieving stock price data.
Utilize the RapidAPI service to interact with the Latest Stock Price API.
Implement methods within the library to retrieve stock prices, historical prices, and other relevant data using the provided endpoints.
Remember to break down each task into smaller subtasks and tackle them one at a time. Use the official Ruby on Rails documentation and relevant resources to guide you through the implementation of each task.

## Installation

1. Clone this repository to your local machine.
2. Install the required dependencies by running `bundle install`.
3. Configure the database settings in `config/database.yml`.
4. Set up the database by running `rails db:create` and `rails db:migrate`.
5. (Optional) If you need seed data, run `rails db:seed`.

## Project Structure

- `/app`: Contains the core application files.
- `/config`: Configuration files for the application.
- `/db`: Database schema and migrations.
- `/lib`: Custom libraries and utility files.
- `/spec`: Test files (RSpec) for the API endpoints.

## Configuration

- Modify any required configuration files in the `/config` directory.
- Set environment variables for sensitive information (e.g., API keys) in `.env` or use a secret management tool.

## Database Setup

- Set up your preferred database (e.g., PostgreSQL) in `config/database.yml`.
- Create the necessary tables by running `rails db:migrate`.
- Optionally, populate the database with initial data using `rails db:seed`.

## Models and Relationships

The API includes the following models and relationships:

- `User`: Represents a user with a one-to-one association to their wallet.
- `Stock`: Represents a stock entity with its wallet.
- `Team`: Represents a team entity with its wallet.
- `Wallet`: The base class for wallets with shared attributes and behaviors for money manipulation. Derived classes are used for specific entity types (e.g., `UserWallet`, `StockWallet`).
- `Transaction`: handle amount transfer beetween wallets

## Wallet System

- The wallet system allows users to deposit and withdraw money between entities.
- Each transaction is recorded in the database and undergoes proper validations.
- The wallet balance for each entity is calculated by summing the transaction records associated with that entity.

## API Endpoints

The API provides the following endpoints:

- `/transactions`: Allows creating, updating, and retrieving transactions.
- `/wallets`: Provides access to wallet details and balances.
- `/users`, `/stocks`, `/teams`: Endpoints for managing user, stock, and team entities.

## Custom Sign-In

- The API includes a custom sign-in mechanism to manage user sessions.
- Use the appropriate endpoint for sign-in and retrieve session tokens for subsequent requests.

## LatestStockPrice Library

- The `LatestStockPrice` library in `/lib` folder provides an interface to retrieve stock price data.
- Utilizes the RapidAPI service to interact with the Latest Stock Price API.
- Methods include `price`, `prices`, and `price_all` endpoints.

## Testing

- Run tests for the API using the RSpec framework with `bundle exec rspec`
