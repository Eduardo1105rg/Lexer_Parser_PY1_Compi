package simbolos;

/*
* Esta clase es la representación de un cuadruplo (op, a1, a2, res)
* Se utiliza para generar el codigo intermedio (tac)
* Actualizacion: Se agrega atributo 'tipo' para el resultado cuando aplica
*/
public class Cuad {
    public String operador;
    public String argumento1;
    public String argumento2;
    public String resultado;
    public String tipo; // tipo del resultado (cuando aplica)

    // Constructor sin tipo (para LABEL, GOTO, IF/IF_FALSE sin resultado, PRINT, etc.)
    public Cuad(String operador, String argumento1, String argumento2, String resultado) {
        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
        this.tipo = null;
    }

    // Constructor con tipo (para operaciones/aridades con resultado tipado)
    public Cuad(String operador, String argumento1, String argumento2, String resultado, String tipo) {
        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
        this.tipo = tipo;
    }

    @Override
    public String toString() {
        if ("LABEL".equals(operador)) {
            return resultado + ":";
        }
        if ("GOTO".equals(operador)) {
            return "GOTO " + resultado;
        }
        if ("IF".equals(operador)) {
            return "IF " + safe(argumento1) + " GOTO " + resultado;
        }
        if ("IF_FALSE".equals(operador)) {
            return "IF_FALSE " + safe(argumento1) + " GOTO " + resultado;
        }
        if ("PRINT".equals(operador)) {
            return "PRINT " + safe(argumento1);
        }
        if ("READ".equals(operador)) {
            return "READ " + safe(resultado) + (tipo != null ? " -> " + tipo : "");
        }
        if ("ALLOC".equals(operador)) {
            return resultado + " = ALLOC " + safe(argumento1) + " " + safe(argumento2);
        }
        if ("GET".equals(operador)) {
            return safe(resultado) + " = GET " + safe(argumento1) + ", " + safe(argumento2) + (tipo != null ? " -> " + tipo : "");
        }
        if ("SET".equals(operador)) {
            return safe(argumento1) + "[" + safe(argumento2) + "] = " + safe(resultado);
        }
        if ("POP_PARAM".equals(operador)) {
            return "POP_PARAM " + safe(argumento1) + " -> " + safe(resultado) + (tipo != null ? " -> " + tipo : "");
        }
        if ("PARAM".equals(operador)) {
            return "PARAM " + safe(argumento1) + (tipo != null ? " -> " + tipo : "");
        }
        if ("RET".equals(operador)) {
            return resultado == null ? "RET" : "RET " + safe(argumento1 != null ? argumento1 : resultado);
        }
        if ("FUNC_BEGIN".equals(operador)) {
            return safe(resultado) + " FUNC_BEGIN";
        }
        if ("FUNC_END".equals(operador)) {
            return safe(resultado) + " FUNC_END";
        }

        if ("=".equals(operador)) {
            String line = safe(resultado) + " = " + safe(argumento1);
            if (tipo != null) line += " -> " + tipo;
            return line;
        }

        String core = safe(resultado) + " = " + safe(argumento1) + " " + operador + (argumento2 != null ? " " + safe(argumento2) : "");
        if (tipo != null) core += " -> " + tipo;
        return core;
    }

    private String safe(String s) { 
        return s == null ? "" : s; 
    }
}