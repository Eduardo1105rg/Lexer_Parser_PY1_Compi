package simbolos;

import java.util.ArrayList;
import java.util.List;

public class TipoExpresiones {

    public String tipoDato; // int, char.

    public Integer valorI; // null en caso de ser [], entero si es [8].
    public Double valorF;
    public Character valorC;
    public String valorS;
    public Boolean valorB;

    // Este es para el trabajo con las listas.
    public List<String> tipos;

    public int tamano; // Para lo del tamaño del valor en las listas.

    // Pruebas para TAC
    public String temp; // Esto es para tener el valor temporal
    public List<Cuad> cuads;

    // Para lo del trabjo con las listas.
    public String idFuncion; // Para realizar la validacion de los argumentos de las funciones.

    public TipoExpresiones(String pTipoDato) {
        this.tipoDato = pTipoDato;
        this.tipos = new ArrayList<>();
        this.tamano = 0;

        // Prueba para TAC
        this.cuads = new ArrayList<>();

        // Para realizar la validacion de los argumentos de las funciones. vamos a
        // guardar el id de la funcion.
        this.idFuncion = "";
    }

    public TipoExpresiones(String tipo, Object valor) {
        this.tipoDato = tipo;
        this.cuads = new ArrayList<>();
        // guardar valor literal como temp para usar en TAC (hoja)
        if (valor != null) {
            this.temp = valor.toString();
            if (valor instanceof Integer) {
                this.valorI = (Integer) valor;
            } else if (valor instanceof Double) {
                this.valorF = (Double) valor;
            } else if (valor instanceof Character) {
                this.valorC = (Character) valor;
            } else if (valor instanceof String) {
                this.valorS = (String) valor;
            } else if (valor instanceof Boolean) {
                this.valorB = (Boolean) valor;
            }
        }
    }

    public TipoExpresiones(String pTipoDato, Integer tamano) {
        this.tipoDato = pTipoDato;
        this.valorI = tamano;
        this.cuads = new ArrayList<>();
        if (tamano != null)
            this.temp = tamano.toString();
    }

    public TipoExpresiones(String pTipoDato, Double tamano) {
        this.tipoDato = pTipoDato;
        this.valorF = tamano;
        this.cuads = new ArrayList<>();
        if (tamano != null)
            this.temp = tamano.toString();
    }

    public TipoExpresiones(String pTipoDato, Character tamano) {
        this.tipoDato = pTipoDato;
        this.valorC = tamano;
        this.cuads = new ArrayList<>();
        if (tamano != null)
            this.temp = tamano.toString();
    }

    public TipoExpresiones(String pTipoDato, String tamano) {
        this.tipoDato = pTipoDato;
        this.valorS = tamano;
        this.cuads = new ArrayList<>();
        if (tamano != null)
            this.temp = tamano;
    }

    public TipoExpresiones(String pTipoDato, Boolean tamano) {
        this.tipoDato = pTipoDato;
        this.valorB = tamano;
        this.cuads = new ArrayList<>();
        if (tamano != null)
            this.temp = tamano.toString();
    }

    public TipoExpresiones(String pTipoDato, int pValor, int pTamano) {
        this.tipoDato = pTipoDato;
        this.valorI = pValor;
        this.tamano = pTamano;
    }

    public TipoExpresiones(String pTipoDato, Character pValor, int pTamano) {
        this.tipoDato = pTipoDato;
        this.valorC = pValor;
        this.tamano = pTamano;
    }

    public TipoExpresiones(String tipoDato, List<String> tipos, int tamano) {
        this.tipoDato = tipoDato;
        this.tipos = tipos;
        this.tamano = tamano;
        this.cuads = new ArrayList<>();
    }

    public String getTipo() {
        return this.tipoDato;
    }

    // Estos es para establecer el id de la funcion cuando se le hace una llamada a
    // funcion.
    public String GetIdFuncion() {
        return this.idFuncion;
    }

    public void SetIdFuncion(String idFuncion) {
        this.idFuncion = idFuncion;
    }

    // Prueba TAC
    // helper para clonar cuads (como estructura)
    public void append(TipoExpresiones otro) {
        if (otro != null && otro.cuads != null) {
            this.cuads.addAll(otro.cuads);
        }
    }
}
