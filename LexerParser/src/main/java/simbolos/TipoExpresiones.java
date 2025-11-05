package simbolos;

public class TipoExpresiones {

    public String tipoDato; // int, char.

    public Integer valorI; // null en caso de ser [], entero si es [8].
    public Double valorF;
    public Character valorC;
    public String valorS;
    public Boolean valorB;

    public TipoExpresiones(String pTipoDato) {
        this.tipoDato = pTipoDato;
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

    public String getTipo() {
        return this.tipoDato;
    }
}
