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

    public TipoExpresiones(String pTipoDato) {
        this.tipoDato = pTipoDato;
        this.tipos = new ArrayList<>();
        this.tamano = 0;
    }

    public TipoExpresiones(String pTipoDato, Integer tamano) {
        this.tipoDato = pTipoDato;
        this.valorI = tamano;
    }

    public TipoExpresiones(String pTipoDato, Double tamano) {
        this.tipoDato = pTipoDato;
        this.valorF = tamano;
    }

    public TipoExpresiones(String pTipoDato, Character tamano) {
        this.tipoDato = pTipoDato;
        this.valorC = tamano;
    }

    public TipoExpresiones(String pTipoDato, String tamano) {
        this.tipoDato = pTipoDato;
        this.valorS = tamano;
    }

    public TipoExpresiones(String pTipoDato, Boolean tamano) {
        this.tipoDato = pTipoDato;
        this.valorB = tamano;
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
    }


    public String getTipo() {
        return this.tipoDato;
    }


}
