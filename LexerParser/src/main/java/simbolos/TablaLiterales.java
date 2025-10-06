package simbolos;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

public class TablaLiterales {
    
    private List<LiteralInfo> tablaLiterales = new ArrayList<>();

    public void  agregarElemento(Object valor, String tipo, int linea, int columna) {
        tablaLiterales.add(new LiteralInfo(valor, tipo, linea, columna));
    }

    public void imprimirTablaLiterales(PrintStream consola) {
        consola.println(">>>> Mostrando la tabla de literales:");
        for (LiteralInfo elemento : tablaLiterales) {
            consola.println("Literal: " + elemento.valor + ", Tipo: " + elemento.tipo + ", Linea: " + elemento.linea + ", Columna: " + elemento.columna);

        }
    }

}
