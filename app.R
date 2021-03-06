#Gabriela Garc�a Facio
#Lab25,UNAM.


    ui <-fluidPage(
        shinyUI(
            tabsetPanel(
                tabPanel("Tareas de bandidos",
                    h1("Tareas de bandidos"),
                    h5(em("Por Gabriela Garc�a Facio")),
                    hr(),
                    p("Estas tareas se caracterizan por presentar al menos dos opciones entre las cuales podemos elegir. Estas opciones se conocen como: "),
                    p(strong("brazos o bandidos.")), 
                    p("Existen muchas formas de bandidos.Este simulador da cuenta de la siguiente:"),
                    tags$ol(
                        tags$li("Est�tica",withMathJax('$$q*(\\alpha)=E[R_{t}|A_{t}=\\alpha]$$'))
                        
                    ),
                    p("Donde el brazo elegido  en el tiempo t, se describe por ", withMathJax('$$A_{t}$$')),
                    p("y la recompensa correspondiente por", withMathJax('$$R_{t}$$')),
                    p("As�, el valor de una ación arbitraria", withMathJax('$$\\alpha$$',"descrita por", withMathJax(
                        '$$q*\\alpha$$'),
                        p("es la recompensa esperada dada esa opci�n."),
                        br(),
                        p("Resolver este tipo de bandidos es trivial, ya que las recompensas se mantienen iguales a trav�s del tiempo. ")
                    ))
                ),
                tabPanel("Bandidos est�ticos",
                    tags$head(
                        
                    ),
                    h1("Instrucciones", style= "color:#000B0E"),
                    p("En pantalla se te presentan 4 botones simulando 4 bandidos. A trav�s de la exploraci�n,",
                 "tu tarea es identificar el brazo que te d� m�s recompensas."),
                    p("Las tablas que se presentan, te permitir�n identificar m�s f�cilmente los feedbacks de cada brazo."),
                    p("Finalmente, puedes volver a empezar, presionando el bot�n rojo."),
                    
                    br(),
                    
                    hr(),
                    #contrucci�n de brazos est�ticos
                    column(width=4,
                        fluidRow(
                            column(width=5,
                                h4("Opci�n 1:"),
                                actionButton("m1_play","�Juega!", class="btn btn-light",
                                    width="100px", style="color: #FFBE33 ",
                                    icon=icon("play",class="fas fa-play"))
                            ),
                            
                            column(width=5,
                                h4("Opci�n 2:"),
                                actionButton("m2_play","�Juega!", class="btn btn-light",
                                    width="100px", style="color: #4EDCD7",
                                    icon=icon("play",class="fas fa-pay"))
                            ),
                            column(width = 5,
                                div(style="position:static;right:1em;",
                                    h4("Opci�n 3: "),
                                    actionButton("m3_play","�Juega!",class="btn btn-light",
                                        width = "100px",style="color:#43BF6E ",
                                        icon=icon("play",class = "fas fa-play")))
                            ),
                            column(width = 5,
                                h4("Opci�n 4: "),
                                actionButton("m4_play","�Juega!",class="btn btn-light",
                                    width="100px",style="color:#DC4E9D ",
                                    icon=icon("play",class="fas fa-play"))
                            )
                            
                        ),
                        #Tabla de resultados      
                        br(),
                        h4("Resultados"),
                        tableOutput("tab")
                    ),
                    #Tabla de registro de eventos
                    column(width=4,
                        h4("Eventos"),
                        tabsetPanel(type="tabs",
                            tabPanel(
                                "Registro de eventos",
                                wellPanel(
                                    id="tPanel",
                                    style="overflow-y:scroll; max-height: 220px",
                                    htmlOutput("res")
                                )
                            )),
                        
                        column(width=7,
                            
                            
                            br(),br(),
                            actionButton("reset", "Volver a empezar", class="btn btn-danger")
                        )
                        
                    )
                    
                )
            )))
    
    
    server <- function(input, output) 
    {
        values = reactiveValues(
            tab = data.frame( Exitos=c(0L,0L,0L,0L),  
                Fracasos=c(0L,0L,0L,0L),
                Jugadas=c(0L,0L,0L,0L),
                row.names = c("Opci�n 1","Opci�n 2","Opci�n 3","Opci�n 4")),
            
            bueno = sample(1:4,1),
            res = data.frame(Juego=integer(),
                Opcion=integer(),
                Resultado=character()) #tabla de resultados
        )
        
        observeEvent(input$m1_play, {
            win = rbinom(1, 1,ifelse(values$bueno==1,.20,.80)) #(�xito,fracaso)
            if (win)
                
                values$tab[1,c(1,3)] = values$tab[1,c(1,3)] + 1L #Registra �xito
            else
                values$tab[1,c(2,3)] = values$tab[1,c(2,3)] + 1L #Registra fracasos
            
            values$res = rbind(data.frame(Juego = nrow(values$res)+1L,
                Opcion = 1L,
                Resultado = ifelse(win,"Ganaste","Perdiste"),
                stringsAsFactors = FALSE),
                values$res)
            
        })
        
        observeEvent(input$m2_play, {
            win = rbinom(1, 1, ifelse(values$bueno == 2,.50, .50))
            if (win)
                values$tab[2,c(1,3)] = values$tab[2,c(1,3)] + 1L
            else
                values$tab[2,c(2,3)] = values$tab[2,c(2,3)] + 1L
            
            values$res = rbind(data.frame(Juego=nrow(values$res)+1L,
                Opcion = 2L,     
                Resultado = ifelse(win,"Ganaste","Perdiste"),
                stringsAsFactors = FALSE),
                values$res)
            
        })
        observeEvent(input$m3_play, {
            win = rbinom(1, 1, ifelse(values$bueno == 3, .10, .90))
            if (win)
                values$tab[3,c(1,3)] = values$tab[3,c(1,3)] + 1L
            else
                values$tab[3,c(2,3)] = values$tab[3,c(2,3)] + 1L
            
            values$res = rbind(data.frame(Juego=nrow(values$res)+1L,
                Opcion = 3L,        
                Resultado = ifelse(win,"Ganaste","Perdiste"),
                stringsAsFactors = FALSE),
                values$res)
        })
        
        observeEvent(input$m4_play, {
            win = rbinom(1, 1, ifelse(values$bueno == 2, 1,0))
            if (win)
                values$tab[4,c(1,3)] = values$tab[4,c(1,3)] + 1L
            else
                values$tab[4,c(2,3)] = values$tab[4,c(2,3)] + 1L
            
            values$res = rbind(data.frame(Juego=nrow(values$res)+1L,
                Opcion = 4L,
                Resultado = ifelse(win,"Ganaste","Perdiste"),
                stringsAsFactors = FALSE),
                values$res)
        })
        
        #Bot�n de reset 
        observeEvent(input$reset, {
            values$tab[] = 0L
            values$res = c()
            values$res = data.frame(Juego=integer(),Opciones=integer(),Resultado=character())
            values$bueno = sample(1:4,1)
            output$guess = renderText("")
            
        })
        
        
        output$tab = renderTable(values$tab, align="ccc")
        output$res = renderTable(values$res,
            include.rownames=TRUE,
            align="ccc")
        
        
    }

shinyApp(ui=ui, server=server)   
