package Codigo_Destino;

public class Cuad_Destino {
    private String operador;
    private String argumento1;
    private String argumento2;
    private String resultado;
    private String tipo;
    private String alcance;
    private String categoria;
    private String nombre;

    // Constructor
    public Cuad_Destino(String operador, String argumento1, String argumento2, String resultado, String tipo,
            String alcance, String categoria, String nombre) {
        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
        this.tipo = tipo;
        this.alcance = alcance;
        this.categoria = categoria;
        this.nombre = nombre;
    }

    // De aqui en adelante se crean los gettes y setters.
    public String GetCategoria() {
        return categoria;
    }

    public String GetOperador() {
        return operador;
    }

    public String GetArgumento1() {
        return argumento1;
    }

    public String GetArgumento2() {
        return argumento2;
    }

    public String GetResultado() {
        return resultado;
    }

    public String GetTipo() {
        return tipo;
    }

    public String GetAlcance() {
        return alcance;
    }

    public String GetNombre() {
        return nombre;
    }

    // Estos son los setters.
    public void SetCategoria(String categoria) {
        this.categoria = categoria;
    }

}