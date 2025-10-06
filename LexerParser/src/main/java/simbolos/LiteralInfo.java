package simbolos;

public class LiteralInfo {
    
    Object valor;
    String tipo;
    int linea;
    int columna;
    
    public LiteralInfo(Object valor, String tipo, int linea, int columna) {
        this.valor = valor;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }

}
