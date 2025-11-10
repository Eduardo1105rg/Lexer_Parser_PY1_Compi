package simbolos;

public class Cuad {
    public String operador;
    public String argumento1;
    public String argumento2;
    public String resultado;

    Cuad (String operador, String argumento1, String argumento2, String resultado) {
        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
    }

    public String toString() {
        if ("LABEL".equals(operador))
            return resultado + ":";
        if ("FUNC_BEGIN".equals(operador))
            return "FUNC " + argumento1 + " BEGIN";
        if ("FUNC_END".equals(operador))
            return "FUNC " + argumento1 + " END";
        if ("PARAM".equals(operador))
            return "PARAM " + argumento1;
        if ("POP_PARAM".equals(operador))
            return "POP_PARAM " + argumento1 + " -> " + resultado;
        if ("CALL".equals(operador)) {
            if (resultado == null) return "CALL " + argumento1 + ", " + argumento2;
            return resultado + " = CALL " + argumento1 + ", " + argumento2;
        }
        if ("RET".equals(operador))
            return "RET " + argumento1;
        if ("=".equals(operador))
            return resultado + " = " + argumento1;
        if (operador.equals("IF_FALSE"))
            return "IF_FALSE " + argumento1 + " GOTO " + resultado;
        if (operador.equals("IF"))
            return "IF " + argumento1 + " GOTO " + resultado;
        if (operador.equals("GOTO"))
            return "GOTO " + resultado;
        if (argumento2 == null)
            return resultado + " = " + operador + " " + argumento1;
        return resultado + " = " + argumento1 + " " + operador + " " + argumento2;
    }
}