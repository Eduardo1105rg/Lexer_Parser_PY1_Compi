package simbolos;

import java.util.ArrayList;
import java.util.List;

public class TokenDecide {
    
    public List<CondicionBloque> condiciones;

    public Token bloqueElse;


    public TokenDecide () {
        this.condiciones = new ArrayList<>();
    }


    public void addCondiBloque(CondicionBloque condiBlo) {
        condiciones.add(condiBlo);
    }

    public void setBloqueElse(Token bloElse) {
        this.bloqueElse = bloElse;
    }


    public List<CondicionBloque> getCondiciones() {
        return this.condiciones;
    }

    public Token getBloqueElese() {
        return this.bloqueElse;
    }

}
