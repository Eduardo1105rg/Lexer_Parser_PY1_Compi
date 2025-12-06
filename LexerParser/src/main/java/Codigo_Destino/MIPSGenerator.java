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
    private Map<String, Function_Description> funciones = new HashMap<>();
    // La idea sera ir almaceando listas de cada parte para tener un acceso mas
    // rapido a ellos. por ejemplo una lista de las globales.
    // O una lista de las locales con su tipo y esas cosas.

    // Constructor
    public MIPSGenerator() {
        codigo_destino_mips = new StringBuilder();
    }

    public void generarCodigoMIPS() {

    }

    // Esya funcion sera la encargada de leer por primera vez el codigo y encontrar
    // lo que va en el .data
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
                            codigo_destino_mips.append("\t" + nombre).append(": .word ").append(valor)
                                    .append("\n");
                            break;
                        case "boolean":
                            String valo = ("true".equals(valor)) ? "1" : "0";
                            codigo_destino_mips.append("\t" + nombre).append(": .word ").append(valo)
                                    .append("\n");
                            break;
                        case "float":
                            codigo_destino_mips.append("\t" + nombre).append(": .float ").append(valor)
                                    .append("\n");
                            break;
                        case "char":
                            String volatil1 = valor;
                            volatil1 = "'" + volatil1 + "'";
                            codigo_destino_mips.append("\t" + nombre).append(": .byte ").append(volatil1).append("\n");
                            break;
                        case "string":
                            String volatil2 = valor;
                            volatil2 = "\"" + volatil2 + "\"";
                            codigo_destino_mips.append("\t" + nombre).append(": .asciiz ").append(volatil2)
                                    .append("\n");
                            break;
                        default:
                            codigo_destino_mips.append("# Tipo no reconocido para ").append(nombre).append("\n");
                    }
                }
            }
        }
        // codigo_destino_mips.append(".text\n"); // Para empezar con la seccion del
        // .text

    }

    // Esta funcion sera la encargada de generar la parte inciar de el segmento
    // .text. La funcion genera la llamada a main la salida del programa
    public void generar_inicio_segmento_text() {
        codigo_destino_mips.append(".text\n"); // Para empezar con la seccion del .text

        // Esta parte de aqui es para definir el main, ir hasta el y despues volver para
        // finalizar el programa.
        codigo_destino_mips.append("    jal main\n");
        codigo_destino_mips.append("    li $v0, 10\n");
        codigo_destino_mips.append("    syscall\n");
    }

    // Esta funcion se encarga de leer las funciones que se registraron en los cuad
    // e irlas traduciendo a codigo MIPS
    public void generar_funciones_segmento_text() {
        // codigo_destino_mips.append("\n.text\n");
        Function_Description actual = null;

        // for (Cuad c : TAC_Generator.cuadGlobales) {
        // String op = c.operador;
        // if (op == null || op.contains("FUNC_BEGIN"))
        // continue;

        // if (op.startsWith("FUNC_") && op.endsWith(":")) {
        // String fname = op;// .substring(5); // quitar "FUNC_"
        // actual = new Function_Description(fname);
        // funciones.put(fname, actual);
        // codigo_destino_mips.append(fname).append(":\n");
        // codigo_destino_mips.append(" addi $sp, $sp, -" + actual.tamanoStack + "\n");
        // // reservar stack
        // // (ejemplo)
        // codigo_destino_mips.append(" sw $ra, 0($sp)\n");
        // } else if (op.equals("POP_PARAM") && actual != null) {
        // actual.addParam(c.resultado);
        // // guardamos los parametros en stack
        // codigo_destino_mips.append(" sw $a").append(c.operador).append(", ")
        // .append(actual.estructura.get(c.resultado))
        // .append("($sp)\n");

        // // Aqui deberia de ir las partes para procesar las demas parte, como otras
        // // funciones

        // } else if (op.equals("FUNC_END") && actual != null) {
        // // Esto es para cuando se encuentre lo del final de la funcion.
        // codigo_destino_mips.append(" lw $ra, 0($sp)\n");
        // codigo_destino_mips.append(" addi $sp, $sp, " + actual.tamanoStack + "\n");
        // codigo_destino_mips.append(" jr $ra\n");
        // actual = null;
        // }
        // }

        // Analizar las funciones.
        analizarFunciones();

        for (Function_Description func : funciones.values()) {
            codigo_destino_mips.append(func.nombre).append(":\n");
            codigo_destino_mips.append("    addi $sp, $sp, -").append(func.tamanoStack).append("\n");
            codigo_destino_mips.append("    sw $ra, 0($sp)\n");

            Map<String, String> temporales = new HashMap<>();
            for (Cuad c : func.instrucciones) {
                codigo_destino_mips.append(traduccion_instruccion(c, func, temporales));
            }
        }

    }

    // Paso 1: separar funciones
    public void analizarFunciones() {
        Function_Description actual = null;
        for (Cuad c : TAC_Generator.cuadGlobales) {
            String op = c.getOperador();
            if (op == null)
                continue;

            System.out.println("Operador actual: " + op);

            // Detectar inicio de función
            if (op.startsWith("FUNC_") && !"FUNC_END".equals(op)) {
                String fname = c.getResultado(); // usar resultado, no operador
                if (fname.equals("principal"))
                    fname = "main";
                actual = new Function_Description(fname);
                funciones.put(fname, actual);
            }

            // Detectar fin de funcion
            else if ("FUNC_END".equals(op) && actual != null) {// && actual != null
                System.out.println("Fin de la funcion: " + actual.nombre);
                calcularStack(actual);
                actual = null;
            }

            // Acumular instrucciones dentro de la función (ignorar FUNC_BEGIN/END)
            else if (actual != null && !"FUNC_BEGIN".equals(op)) {
                // System.out.println("Operador actual en el calculo de instrucciones: " + op);
                actual.instrucciones.add(c);
            }
        }
    }

    // Paso 2: calcular stack
    private void calcularStack(Function_Description actual) {
        int size = 4; // espacio para $ra
        for (Cuad c : actual.instrucciones) {
            String op = c.getOperador();
            System.out.println("Operador actual en el calculo de stack: " + op);
            if (op == null)
                continue;

            // Detectar parámetros
            if ("POP_PARAM".equals(op)) {
                actual.addParam(c.getResultado());
            }

            // Detectar variables locales (no temporales, lo que se este usando para calculo
            // no es impornate para guardarle pila.)
            else if ("=".equals(op)) {
                String var = c.getResultado();
                if (var != null && !var.startsWith("t")) {
                    actual.addLocal(var);
                }
            }
        }
        actual.tamanoStack = size + actual.tamanoStack;
    }

    public String traduccion_instruccion(Cuad c, Function_Description func, Map<String, String> temporales) {
        StringBuilder cadena = new StringBuilder(); // Cadena para la construccion de
        String op = c.getOperador();

        // POP_PARAM → Estos son los primeros que guardamos en el stack en el caso de
        // que sean mas de 3
        // debemos de hacer algo para sacarlos de la pila en donde vienen y volverlos a
        // guardar antes de redimensionar.
        if ("POP_PARAM".equals(op)) {
            int offset = func.estructura.get(c.getResultado());
            // suponemos que los params llegan en $a0, $a1, $a2..
            cadena.append("    sw $a").append(c.getArgumento1()).append(", ").append(offset).append("($sp)\n");
        }

        // Asignación simple (=)
        else if ("=".equals(op)) {
            String var = c.getResultado();
            String valor = c.getArgumento1();

            // Si es constante
            if (valor.matches("^-?\\d+$")) {
                cadena.append("    li $t0, ").append(valor).append("\n");
                cadena.append("    sw $t0, ").append(func.estructura.get(var)).append("($sp)\n");
            }
            // Si es otra variable
            else if (func.estructura.containsKey(valor)) {
                int off = func.estructura.get(valor);
                cadena.append("    lw $t0, ").append(off).append("($sp)\n");
                cadena.append("    sw $t0, ").append(func.estructura.get(var)).append("($sp)\n");
            }
            // Si es temporal
            else if (temporales.containsKey(valor)) {
                cadena.append("    move $t0, ").append(temporales.get(valor)).append("\n");
                cadena.append("    sw $t0, ").append(func.estructura.get(var)).append("($sp)\n");
            } else {
                // esta parte seria para manejar lo que esta en .data
            }
        }

        // 3. Operaciones aritmeticas (+, -, *, /, %)
        else if ("+".equals(op) || "-".equals(op) || "*".equals(op) || "/".equals(op)) {
            String res = c.getResultado();
            String arg1 = c.getArgumento1();
            String arg2 = c.getArgumento2();

            // cargar arg1
            if (func.estructura.containsKey(arg1)) {
                cadena.append("    lw $t1, ").append(func.estructura.get(arg1)).append("($sp)\n");
            } else if (arg1.matches("^-?\\d+$")) {
                cadena.append("    li $t1, ").append(arg1).append("\n");
            } else if (temporales.containsKey(arg1)) {
                cadena.append("    move $t1, ").append(temporales.get(arg1)).append("\n");
            }

            // cargar a2 en $t2
            if (func.estructura.containsKey(arg2)) {
                cadena.append("    lw $t2, ").append(func.estructura.get(arg2)).append("($sp)\n");
            } else if (arg2.matches("^-?\\d+$")) {
                cadena.append("    li $t2, ").append(arg2).append("\n");
            } else if (temporales.containsKey(arg2)) {
                cadena.append("    move $t2, ").append(temporales.get(arg2)).append("\n");
            }

            // operación
            switch (op) {
                case "+":
                    cadena.append("    add $t0, $t1, $t2\n");
                    break;
                case "-":
                    cadena.append("    sub $t0, $t1, $t2\n");
                    break;
                case "*":
                    cadena.append("    mult $t1, $t2\n");
                    cadena.append("    mflo $t0\n");
                    break;
                case "/":
                    cadena.append("    div $t1, $t2\n");
                    cadena.append("    mflo $t0\n");
                    break;
                case "%":
                    cadena.append("    div $t1, $t2\n");
                    cadena.append("    mfhi $t0\n");
                    break;
            }

            // guardar resultado
            if (res.startsWith("t")) {
                temporales.put(res, "$t0");
            } else if (func.estructura.containsKey(res)) {
                cadena.append("    sw $t0, ").append(func.estructura.get(res)).append("($sp)\n");
            }
        }

        // Esto es para el manejo de la potencia, pero falta por implementar el modo de
        // calculo.
        else if ("^".equals(op)) {
            // TODO: implementar potencia con bucle (multiplicación repetida).
            cadena.append("    # Potencia no implementada: usa rutina auxiliar o bucle\n");
        }
        // 4. RET → retorno de función
        else if ("RET".equals(op)) {
            String ret = c.getArgumento1(); // en tu TAC puede venir el valor a devolver

            // Caso especial: main no devuelve nada
            if ("main".equals(func.nombre)) {
                cadena.append("    # main no retorna valor\n");
            } else {
                if (ret != null) {
                    if (func.estructura.containsKey(ret)) {
                        cadena.append("    lw $v0, ").append(func.estructura.get(ret)).append("($sp)\n");
                    } else if (temporales.containsKey(ret)) {
                        cadena.append("    move $v0, ").append(temporales.get(ret)).append("\n");
                    } else if (ret.matches("^-?\\d+$")) {
                        cadena.append("    li $v0, ").append(ret).append("\n");
                    }
                }
            }

            // Terminacion para todas las funciones.
            cadena.append("    lw $ra, 0($sp)\n");
            cadena.append("    addi $sp, $sp, ").append(func.tamanoStack).append("\n");
            cadena.append("    jr $ra\n");
        }

        return cadena.toString();
    }

    public void mostrar_codigo_destino_mips() {
        System.out.println(codigo_destino_mips.toString());
    }

    public void mostrar_datos_funciones() {
        for (Function_Description func : funciones.values()) {
            // System.out.println("Funcion: " + func.nombre);
            // System.out.println("Stack size: " + func.tamanoStack);
            // System.out.println("Parametros: " + func.params);
            func.mostrar_estructura();
        }
    }

}
