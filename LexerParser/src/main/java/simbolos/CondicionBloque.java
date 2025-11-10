package simbolos;
import java.util.List;

public class CondicionBloque {
    public  TipoExpresiones condicion;
    public Token bloque;
    
    public List<Cuad> tac; // El tac capturado del bloque

    public CondicionBloque(TipoExpresiones condicion, Token bloque) {
        this.condicion = condicion;
        this.bloque = bloque;
    }

    public void setTac (List<Cuad> tac) {
        this.tac = tac;
    }

    public List<Cuad> getTac () {
        return this.tac;
    }

    public TipoExpresiones getCondicion() {
        return this.condicion;
    }

    public Token getToken() {
        return this.bloque;
    }
}
