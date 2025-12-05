/*
* Clase para generar codigo MIPS
* Esta clase busca ser una etapa completamente separada del analisis (lex, sin, seman)
* para generar codigo MIPS a partir del TAC generado en la generacion de codigo intermedio.
* 
* Idea: Recorrer cada cuadruplo generado y traducirlo a instrucciones MIPS con ayuda de la tabla de simbolos
*/
package Codigo_Destino;

import simbolos.TAC_Generator;
import simbolos.Cuad;
import java.util.*;

public class MIPSGenerator {

    // Lo vamos a ir contruyendo poco a poco con lo del string builder.
    private StringBuilder codigo_destino_mips;

    // La idea sera ir almaceando listas de cada parte para tener un acceso mas
    // rapido a ellos. por ejemplo una lista de las globales.
    // O una lista de las locales con su tipo y esas cosas.

    // Constructor
    public MIPSGenerator() {
        codigo_destino_mips = new StringBuilder();
    }

    public void generarCodigoMIPS() {

    }

    public void generar_segmento_data_var_globales() {
        codigo_destino_mips.append(".data\n"); // agregamos lo del segmento.

        // leemos la lista global de cuads
        for (Cuad cuad : TAC_Generator.cuadGlobales) {
            if (cuad.operador != null && cuad.operador.contains("FUNC_")) {
                // dentroDeFunciones = true;
                break;
            } else {
                if ("=".equals(cuad.operador)) {
                    String nombre = cuad.resultado;
                    String tipo = cuad.tipo;
                    String valor = cuad.argumento1;

                    switch (tipo) {
                        case "int":
                            codigo_destino_mips.append(nombre).append(": .word ").append(valor)
                                    .append("\n");
                            break;
                        case "boolean":
                            String valo = ("true".equals(valor)) ? "1" : "0";
                            codigo_destino_mips.append(nombre).append(": .word ").append(valo)
                                    .append("\n");
                            break;
                        case "float":
                            codigo_destino_mips.append(nombre).append(": .float ").append(valor)
                                    .append("\n");
                            break;
                        case "char":
                            String volatil1 = valor;
                            volatil1 = "'" + volatil1 + "'";
                            codigo_destino_mips.append(nombre).append(": .byte ").append(volatil1).append("\n");
                            break;
                        case "string":
                            String volatil2 = valor;
                            volatil2 = "\"" + volatil2 + "\"";
                            codigo_destino_mips.append(nombre).append(": .asciiz ").append(volatil2).append("\n");
                            break;
                        default:
                            codigo_destino_mips.append("# Tipo no reconocido para ").append(nombre).append("\n");
                    }
                }
            }
        }
        codigo_destino_mips.append(".text\n"); // Para empezar con la seccion del .text

    }

    public void mostrar_codigo_destino_mips() {
        System.out.println(codigo_destino_mips.toString());
    }
}
