package utils;

import simbolos.TipoExpresiones;

public class ObtenerValorEnString {

    public static String operandoString(TipoExpresiones expr) {
        if (expr == null)
            return "null";
        if (expr.valorI != null)
            return expr.valorI.toString();
        if (expr.valorF != null)
            return expr.valorF.toString();
        if (expr.valorB != null)
            return expr.valorB ? "true" : "false";
        if (expr.valorS != null) {
            String s = expr.valorS.replace("\\", "\\\\").replace("\"", "\\\"");
            return "\"" + s + "\""; // Para que sea "string"
        }
        if (expr.valorC != null) {
            char c = expr.valorC;
            String cs;
            switch (c) {
                case '\\':
                    cs = "\\\\";
                    break;
                case '\'':
                    cs = "\\'";
                    break;
                case '\n':
                    cs = "\\n";
                    break;
                case '\t':
                    cs = "\\t";
                    break;
                case '\r':
                    cs = "\\r";
                    break;
                default:
                    cs = String.valueOf(c);
            }
            return "'" + cs + "'";
        }
        if (expr.temp != null) // Esta parte tambien es de la correccion.
            return expr.temp;
        return "null";
    }
}
