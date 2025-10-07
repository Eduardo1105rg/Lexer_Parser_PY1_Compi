package utils;

public class ErroresInfo {

    public final String tipo; // "LEXICO" o "SINTACTICO"
    public final int linea;
    public final int columna;
    public final String mensaje;

    public ErroresInfo(String tipo, int linea, int columna, String mensaje) {
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
        this.mensaje = mensaje;
    }

    
    public String mostrarError() {
        return String.format("[%s], Linea: %d, Columna: %d, Mensaje: %s", tipo, linea, columna, mensaje);
    }

    
}
