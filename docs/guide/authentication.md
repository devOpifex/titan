# Authentication

If you run shiny applications and plumber APIs on a secure server behind a proxy then you probably do not need authentication. If said applications are exposed  publicly then you might want to use authentication so that the metrics are not publicly accessible.

Prometheus supports [basic authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication), by default it does not use any, but optionally a user and password can be specified in the `prometheus.yml` so that these are used when hitting the `/metrics` endpoint.

This means the endpoint needs to be secured with the same user and password.

## Securing the endpoint

Use the helper function `generateBasicAuth` to create a token based on a username and password. Note that the function throws a warning: this function should not be left as-is in your application or plumber API.

```r
generateBasicAuth(
  username = "titan",
  password = "secret2020!"
) 
```

```
[1] "Basic dGl0YW46c2VjcmV0MjAyMCE="
Warning message:
Do not deploy or share this 
```

Once the authentication token is created it can be used in `setAuthentication`. __The token should not be displayed in the code as in the example below,__ ideally should be an environment variable or option.

```r
library(titan)
library(shiny)

setAuthentication("Basic dGl0YW46c2VjcmV0MjAyMCE=")

ui <- fluidPage(
  h2("Secure endpoint")
)

server <- function(input, output){}

titanApp(ui, server, visits = "visits")
```

Running the application above then visiting `/metrics` should display `Unauthorized`. Indeed, visiting the endpoint from the browser executes a simple `GET` request that does not feature bear the token: it is unauthorised.

One can open a new R session and use the convenience function `getMetrics` to test the endpoint. The function optionally takes a second argument, the authentication to use.

```r
titan::getMetrics(
  "http://127.0.0.1:3145/", 
  auth = "Basic dGl0YW46c2VjcmV0MjAyMCE="
)
```

```
Response [http://127.0.0.1:3145/metrics]
  Date: 2020-12-13 10:46
  Status: 200
  Content-Type: text/plain
  Size: 81 B
# HELP visits Number of visits to the application
# TYPE visits counter
visits 1
```

This returns the metrics as it is, unlike via the browser, authenticated.

## Prometheus

Then one can place the username and password in the job configuration.

```yml
- job_name: my-api
  basic_auth:
    username: titan
    password: secret2020!
```
