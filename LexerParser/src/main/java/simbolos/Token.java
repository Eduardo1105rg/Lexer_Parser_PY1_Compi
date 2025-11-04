package simbolos;

public class Token {
    public String nombre;
    public String tipo;
    public String ambito;
    public Object valor;
    public String categoria;
    public int linea;
    public int columna;
    
    public Token (String nombre, String tipo, String ambito, Object valor, String categoria, int linea, int columna) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.ambito = ambito;
        this.valor = valor;
        this.categoria = categoria;
        this.linea = linea;
        this.columna = columna;
    }

    public String getNombre() {
        return this.nombre;
    }

    public String getTipo() {
        return this.tipo;
    }

    public String getAmbito() {
        return this.ambito;
    }

    public String getValor() {
        return this.valor.toString();
    }

    public String getCategoria() {
        return this.categoria;
    }

    public int getLinea() {
        return this.linea;
    }
    public int getColumna() {
        return this.columna;
    }

    public void mostrarToken() {
        System.out.println("Nombre: " + this.nombre + ", Tipo: " + this.tipo + ", Ambito: " + this.ambito + "Categoria:" + this.categoria + ", Valor: " + this.valor + ", Linea: " + this.linea + ", Columna: " + this.columna);
    }
}
