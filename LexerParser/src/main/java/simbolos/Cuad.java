package simbolos;

public class Cuad {
    public String operador;
    public String argumento1;
    public String argumento2;
    public String resultado;

    public Cuad(String operador, String argumento1, String argumento2, String resultado) {
        this.operador = operador;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
        this.resultado = resultado;
    }

    @Override
    public String toString() {
        if ("LABEL".equals(operador))        {
            return resultado + ":";
        }
        if ("FUNC_BEGIN".equals(operador)){
            return "FUNC " + argumento1 + " BEGIN";
        }
        if ("FUNC_END".equals(operador)) {
            return "FUNC " + argumento1 + " END";
        }
        if ("PARAM".equals(operador)) {
            return "PARAM " + argumento1;
        }
        if ("POP_PARAM".equals(operador)) {
            return "POP_PARAM " + argumento1 + " -> " + resultado;
        }
        if ("CALL".equals(operador)) {
            return (resultado == null)
                                                ? "CALL " + argumento1 + ", " + argumento2
                                                : resultado + " = CALL " + argumento1 + ", " + argumento2;
        }
        if ("RET".equals(operador)) {
            return "RET " + argumento1;
        }
        if ("PRINT".equals(operador)) {
            return "PRINT " + argumento1;
        }
        if ("READ".equals(operador)) {
            return "READ " + argumento1 + " -> " + resultado;
        }
        if ("=".equals(operador)) {
            return resultado + " = " + argumento1;
        }
        if ("IF_FALSE".equals(operador)) {
            return "IF_FALSE " + argumento1 + " GOTO " + resultado;
        }
        if ("IF".equals(operador)) {
            return "IF " + argumento1 + " GOTO " + resultado;
        }
        if ("GOTO".equals(operador)) {
            return "GOTO " + resultado;
        }
        if ("ALLOC".equals(operador)) {
            return resultado + " = ALLOC " + argumento1 + " " + argumento2;
        }
        if ("GET".equals(operador)) {
            return resultado + " = " + argumento1 + "[" + argumento2 + "]";
        }
        if ("SET".equals(operador)) {
            return argumento1 + "[" + argumento2 + "] = " + resultado;
        }
        if (argumento2 == null) {
            return resultado + " = " + operador + " " + argumento1;
        }
        return resultado + " = " + argumento1 + " " + operador + " " + argumento2;
    }
}