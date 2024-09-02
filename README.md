# Shypple

Shypple is a Ruby application that helps you find the best shipping routes between ports. You can search for the cheapest direct route, the cheapest route, or the fastest route.

## Features

- Search for the cheapest direct route between two ports.
- Search for the cheapest route between two ports.
- Search for the fastest route between two ports.

## Prerequisites

- Ruby 2.7 or later
- Bundler

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/HussainNiazi120/shypple.git
   cd shypple
   ```

2. Install the dependencies:

   ```
   bundle install
   ``` 

## Usage

1. Run the application:
  
   ```
   ruby shypple.rb
   ```

2. Follow the prompts to enter the origin port, destination port, and search type.

### Example
    Enter origin port: CNSHA
    Enter destination port: NLRTM
    Enter search type (cheapest-direct, cheapest, fastest): cheapest

## Docker

You can also run the application using Docker.

### Build the Docker Image
```
docker build -t shypple .
```

### Run the Docker Container
```
docker run -it shypple
```

## Development
### Running Tests
To run the tests, use the following command:
```
bundle exec rspec
```

```
cucumber
```