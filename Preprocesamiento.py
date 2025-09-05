import pandas as pd

# Leer el archivo CSV
df = pd.read_csv("restaurant_orders.csv")

# Normalizamos a minúsculas para evitar problemas con mayúsculas/minúsculas
df["Payment Method"] = df["Payment Method"].str.lower()

# Reemplazar todo lo que no sea 'cash' por 'card'
df["Payment Method"] = df["Payment Method"].apply(lambda x: "cash" if x == "cash" else "card")

# Guardar el resultado en un nuevo archivo
df.to_csv("archivo1.csv", index=False)

print("Columna transformada y archivo guardado como 'archivo1.csv'")
