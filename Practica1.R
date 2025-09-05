library(plotly)
library(dplyr)

# Ruta
df <- read.csv("C:/Users/rted-/Downloads/archivo1.csv")

# Renombrar columnas
colnames(df) <- tolower(gsub(" ", ".", colnames(df)))


# Normalizar columna Payment Method (cash vs card)
df$payment.method <- ifelse(tolower(df$payment.method) == "cash", "cash", "card")

# Clasificar Quantity en <=2 y >2
df <- df %>%
  mutate(
    quantity.cat = ifelse(quantity <= 2, "<=2", ">2"),
    factor_pago = ifelse(payment.method == "cash", 1, 2),
    ventas = quantity * factor_pago
  )

#Cubo OLAP
ventas <- df %>%
  group_by(payment.method, food.item, quantity.cat) %>%
  summarise(ventas = sum(ventas), .groups = "drop")

# Mapear coordenadas
x_map <- setNames(0:(length(unique(ventas$payment.method)) - 1), unique(ventas$payment.method))
y_map <- setNames(0:(length(unique(ventas$food.item)) - 1), unique(ventas$food.item))
z_map <- setNames(0:(length(unique(ventas$quantity.cat)) - 1), unique(ventas$quantity.cat))

ventas <- ventas %>%
  mutate(
    x = x_map[payment.method],
    y = y_map[food.item],
    z = z_map[quantity.cat]
  )

# Graficar cubo OLAP 3D
fig <- plot_ly(
  ventas,
  x = ~ x,
  y = ~ y,
  z = ~ z,
  type = "scatter3d",
  mode = "markers+text",
  text = ~ paste("<br>USD:", ventas),
  marker = list(
    size = 8,
    color = ~ ventas,
    colorscale = "Viridis",
    opacity = 0.8
  )
) %>%
  layout(
    scene = list(
      xaxis = list(title = "Payment method", tickvals = 0:2, ticktext = unique(ventas$payment.method)),
      yaxis = list(title = "Food Item", tickvals = 0:(length(unique(ventas$food.item)) - 1), ticktext = unique(ventas$food.item)),
      zaxis = list(title = "Quantity", tickvals = 0:1, ticktext = unique(ventas$quantity.cat))
    ),
    title = "Cubo OLAP (Ventas por Payment, Food Item y Quantity)"
  )

fig
