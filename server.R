library(shiny)
library(ggplot2)


# server logic for fitting various model on exemplary data
shinyServer(function(input, output) {
        
  output$distPlot <- renderPlot({
    #dataset
    df<-DNase
    
    #generate sequence of x-values for logarithmic plotting of fitted models
    MaxC<-max(df$conc)
    #slightly messy sequence generation, but works for this purpose
    xNew<-as.data.frame(c(2:round(MaxC+1) %o% 10^(-2:0)))
    colnames(xNew)<-c("conc")
    
    #default backup sequence of fitted data
    fitted<-rep(0, times=100)
    
    #fit hyperbolic model, this is the commonly used model for this type of data:
    if(input$method=="hyp"){
            fit<-nls(formula = density ~ ((A*conc)/(B+conc)), data=DNase,
              control = list(maxiter = 100))
            fitted<-predict(fit, newdata=xNew)
    }
    
    #fit linear model:
    if(input$method=="linear"){
            
            fit<-lm(density~conc, data=DNase)
            fitted<-predict(fit, newdata=xNew)
    }
    
    #fit logarithmic model:
    if(input$method=="logr"){
            
            fit<-nls(formula = density ~ A+ B*log(conc), data=DNase,
                     control = list(maxiter = 100))
            fitted<-predict(fit, newdata=xNew)
    }
    
    #fit square root model:
    if(input$method=="sqrt"){
            
            fit<-nls(formula = density ~ A+ B*sqrt(conc), data=DNase,
                     control = list(maxiter = 100))
            fitted<-predict(fit, newdata=xNew)
    }
    
    #fit user defined model:
    # this is the core of the application
    if(input$method=="ud"){
            
            fit<-nls(formula = input$formula, data=DNase,
                     control = list(maxiter = 100))
            fitted<-predict(fit, newdata=xNew)
    }
    
    
    #fitted data
    dfFit<-cbind(xNew, fitted)
    
    #print model formula
    output$modelUsed<-renderText({
           
            paste(format(eval(fit$call$formula)))
    })
    
    #print residual standard error of fit
    output$Rse<-renderText({
            
            paste(round(summary(fit)$sigma,4))
    })
    
    #plot output including data and fitted model
    p<-ggplot(df, aes(x=conc, y=density))+theme_classic()+
          geom_point(shape=23,alpha=0.5, aes(color=Run))+
          geom_line(data=dfFit, aes(x=xNew, y=fitted))+
          labs(x="concentration", y="optical density")
    
    #switch to logarithmic x-scale if selected by the user
    if(input$logScale==TRUE){
            p+scale_x_log10()
    } else {
            p
    }
    
  })
  
})
