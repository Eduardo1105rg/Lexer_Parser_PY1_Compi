package simbolos;

public class TipoLista {
    public String tipoBase; // int, char.
    public Integer tamano; // null en caso de ser [], entero si es [8].

    public TipoLista(String tipoBase, Integer tamano) {
        this.tipoBase = tipoBase;
        this.tamano = tamano;
    }

    
}
