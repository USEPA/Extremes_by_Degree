#' imp_model
#'
#' @export
#'
imp_model <- function(df) {
  approxfun(x = df$modelUnitValue, y = df$value)
}

#' add_linear_row
#'
#' @export
#'
add_linear_row <- function(df) {
  model <- lm(value ~ modelUnitValue, data = df |> tail(2))
  next_x <- 30
  next_y <- predict(model, newdata = data.frame(modelUnitValue = next_x))
  rbind(df, data.frame(modelUnitValue = next_x,
                       value = next_y)
  )
}
