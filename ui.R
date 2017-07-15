library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interactive Fit Model Testing"),
  
  tabsetPanel(
          #Documentation tab
          tabPanel("Documentation", 
                   HTML(paste(
                        "This application enables the user to test several pre-defined fitting models and 
                        arbitrary user-defined fitting functions" ,"<br/>",
                        "interactively by simply providing the function to a test box.
                        The example data is the concentration dependent readout" ,"<br/>",
                        "of an ELISA assay format for multiple Runs (DNAse dataset)." ,"<br/>",
                        "<br/>",
                        "The user-defined function requires the form
                         density ~ f(conc,...), where at least one additional parameter" ,"<br/>",
                         "beyond the variable conc has to be used. 
                         Select *User Defined* in the drop-down menu to use this input." ,"<br/>",
                           "Please note, that not all characters can be used as Variables (e.g. \"C\")." ,"<br/>",
                           "Exemplary functions with working syntax are" ,"<br/>",
                        "<br/>",
                      "density ~ A*conc^B" ,"<br/>",
                      "density ~ A*conc^B-conc+Z*log(conc)","<br/>",
                      "<br/>",
                      "The documented code for this Shiny application can be found under
                      githublink","<br/>",
                      "Happy fitting!")
                   )
                   ),
          
          #Application tab
          tabPanel("Application",
                  
                  sidebarLayout(
                # Sidebar with fit control
                    sidebarPanel(
                            h5("Select your fitting model of choice
                               or create a user-defined fitting formula
                               with the text input below"),
                            
                            selectInput("method", "Model:",
                                        c("Linear" = "linear",
                                          "Logarithmic" = "logr",
                                          "Square root"="sqrt",
                                          "Hyperbolic" = "hyp",
                                          "User Defined"="ud")),
                            
                            h5("The function below requires the form
                               density ~ f(conc,...), where at least one additional
                               parameter beyond the variable conc has to be used. 
                               Select *User Defined* in the drop-down menu to use this input"),
                            
                            textInput("formula",label="User defined fitting function:",
                                      value="density ~ A*conc^B-conc+Z*log(conc)"),
                            hr(),
                            h5("Model used for fitting: "),
                            span(textOutput("modelUsed"),style="color:red"),
                            
                            h5("Residual standard error of fit:"),
                            span(textOutput("Rse"),style="color:red")
                            
                    ),
                    
                    # Show a plot of the generated distribution
                    mainPanel(
                            h5("Concentration dependent readout of an ELISA assay format
                               for multiple Runs. The application provides the chance to
                               test several pre-defined fitting models and an option to
                               fit user-specified functions."),
                            hr(),
                            h5("Check this box to check the fit for low concentrations"),
                            checkboxInput("logScale", label="Plot conc on log scale"),
                            hr(),
                        plotOutput("distPlot")
                    )
                  )
                )
        )
  
  
))
