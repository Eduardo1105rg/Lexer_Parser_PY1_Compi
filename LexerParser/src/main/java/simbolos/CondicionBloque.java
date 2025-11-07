package simbolos;

public class CondicionBloque {
    public  TipoExpresiones condicion;
    public Token bloque;

    public CondicionBloque(TipoExpresiones condicion, Token bloque) {
        this.condicion = condicion;
        this.bloque = bloque;
    }


    public TipoExpresiones getCondicion() {
        return this.condicion;
    }

    public Token getToken() {
        return this.bloque;
    }


}
