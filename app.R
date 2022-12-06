#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(googlesheets4)
library(shinyTime)
library(tidyverse)
library(bslib, warn.conflicts = FALSE)

choix_STA <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "STA")

choix_Type <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "Type")

choix_Desc <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "Desc")

choix_Acteur <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "actor")

#choix_Pays <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "pays")

choix_Lieu <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "lieu")

choix_Admin <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "localite")

pays <- unique(as.data.frame(choix_Admin$pays))

lieu <- unique(as.data.frame(choix_Lieu$lieu))


# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "cerulean",
                          base_font = font_google("Righteous"),
                          "font-size-base" = "0.6rem"),
  titlePanel(title = span(img(src = "logo_undss.png", height = 50), "Incident Registration")),
  fluidRow(
    column(3, style = "border: 2px dashed blue;",
           selectizeInput(inputId = "id_Cat", label = "Catégorie: ",
                          choices=as.vector(choix_STA$STA),width = "180px"),
           
           selectizeInput(inputId = "id_Inc", label = "Type de l'Incident: ",
                          choices=as.vector(choix_Type$Type),width = "180px"),
           
           dateInput("date1", "Date de l'Incident:", format = "dd/mm/yy",width = "180px"),
           
           textInput("time1", "Heure de l'Incident:(exemple: 04:00)", value = "00:00",width = "180px"),
           
           selectizeInput(inputId = "id_Desc", label = "Description de l'Heure: ",
                          choices=as.vector(choix_Desc$Description),width = "180px"),
           
           selectizeInput(inputId = "id_Acteur", label = "Acteur: ",
                          choices=as.vector(choix_Acteur$acteur),width = "180px"),
           
           textInput(inputId = "name", label = "Description de l'acteur",width = "180px"),
           
           selectizeInput(inputId = "id_Touch", label = "Partie Touchée: ",
                          choices=as.vector(choix_Acteur$acteur),width = "180px"),
           
           textInput(inputId = "name1", label = "Description de la partie touchée",width = "180px"),
           
           
           numericInput(inputId = "nbr_mort_acteur", label = "Nombre de mort chez l'acteur", value = 0, min = 0,width = "180px"),
           numericInput(inputId = "nbr_bless_acteur", label = "Nombre de blessés chez l'acteur", value = 0, min = 0,width = "180px"),
           
           numericInput(inputId = "nbr_mort_touch", label = "Nombre de mort chez la partie touchée", value = 0, min = 0,width = "180px"),
           numericInput(inputId = "nbr_bless_touch", label = "Nombre de blessés chez la partie touchée", value = 0, min = 0,width = "180px"),
           
           numericInput(inputId = "nbr_mort_milit", label = "Nombre de mort militaires", value = 0, min = 0,width = "180px"),
           numericInput(inputId = "nbr_bless_milit", label = "Nombre de militaires blessés", value = 0, min = 0,width = "180px"),
           
           numericInput(inputId = "nbr_pers_arret", label = "Nombre de personnes arrêtées ou détenues", value = 0, min = 0,width = "180px"),
           numericInput(inputId = "nbr_pers_enlev", label = "Nombre de personnes enlevées", value = 0, min = 0,width = "180px")
    ),
    
    column(3,style = "border: 2px dashed orange;",
           
           selectizeInput(inputId = "id_Pays", label = "Pays: ",
                          choices=pays,width = "180px"),
           
           textInput(inputId = "name2", label = "Source",width = "180px"),
           
           #uiOutput(outputId = "columns"),
           uiOutput("ui.id_admin1"),
           uiOutput("ui.id_admin2"),
           uiOutput("ui.id_admin3"),
           uiOutput("ui.id_admin4"),
           uiOutput("ui.lat"),
           uiOutput("ui.long"),
           
           textInput(inputId = "other_location", label = "Autre lieu",width = "180px"),
           
           textInput(inputId = "road", label = "Axe routier",width = "180px"),
           
           selectizeInput(inputId = "id_Lieu", label = "Précision du Lieu: ",
                          choices=lieu,width = "180px"),
           
           checkboxInput("Children_Affected", "Enfants touchés", FALSE),
           checkboxInput("Refugees_IDPs_Affected", "Réfugiés, PDI touchés", FALSE),
           checkboxInput("UN_Affected", "ONU touché ", FALSE),
           checkboxInput("Humanitarians_Affected", "Humanitaires touchés ", FALSE),
           checkboxInput("Officials_Institutions_Affected", "Fonctionnaires, institutions touchés", FALSE),
           checkboxInput("Attack", "Attaque", FALSE),
           checkboxInput("Indirect", "  Tir indirect ", FALSE),
           checkboxInput("Drone", "Drone", FALSE),
           checkboxInput("PBIED", "EEI sur personne", FALSE),
           checkboxInput("VBIED", "EEI sur véhicule", FALSE),
           checkboxInput("EEI", "IED", FALSE),
           checkboxInput("PBIED_Attempt", "Tentative d'EEI sur personne", FALSE)),
    
    column(3,style = "border: 2px dashed green;",
           checkboxInput("VBIED_Attempt", "Tentative d'EEI sur véhicule", FALSE),
           checkboxInput("IED_Attempt", "Tentative d'EEI ", FALSE),
           checkboxInput("Road_Block", "Barrage", FALSE),
           checkboxInput("Ambush", "Embuscade", FALSE),
           checkboxInput("Car_Jacking", "Vol de voiture à main armée", FALSE),
           checkboxInput("Raid_Incursion", "Incursion", FALSE),
           checkboxInput("Livestock_Theft", "Vol de bétail", FALSE),
           checkboxInput("Assassinat", "Assassinat", FALSE),
           checkboxInput("Abduction_Kidnapping", "Enlèvement", FALSE),
           checkboxInput("Displacement", "Déplacement", FALSE),
           checkboxInput("Harassment_ThreatsZakat", "Harcèlement, menace, zakat ", FALSE),
           checkboxInput("SGBV", "Violence sexuelle, Dimension genre", FALSE),
           checkboxInput("Sighting", "Action de repérage ", FALSE),
           checkboxInput("Ratissage_Patrouille", "Ratissage, patrouille ", FALSE),
           checkboxInput("Accrochage", "Accrochage", FALSE),
           checkboxInput("Aerial_Bombing", "Bombardement aérienne", FALSE),
           checkboxInput("Arms_Cache", "Cache d'armes", FALSE),
           checkboxInput("Reddition", "Reddition", FALSE),
           checkboxInput("Intra_Intercommunal_Violence", "Violence inter ou intracommunautaire", FALSE),
           textAreaInput(inputId = "Comment", label = "Description narrative",width = "180px"),
           
           actionButton("submit","Enregistrer")
    )
  ),
  #verbatimTextOutput("verb")
  textOutput("text")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$ui.id_admin1 <- renderUI({
    a1 <- as.data.frame(choix_Admin) %>%
      filter(pays %in% input$id_Pays) %>%
      select(region)
    items <- unique(a1)
    selectizeInput(inputId = "id_Admin1", label = "Région", choices = items,width = "180px")
  }
  )
  
  output$ui.id_admin2 <- renderUI({
    a2 <- as.data.frame(choix_Admin) %>%
      filter(region %in% input$id_Admin1) %>%
      select(province)
    items2 <- unique(a2)
    selectizeInput(inputId = "id_Admin2", label = "Province", choices = items2,width = "180px")
  }
  )
  
  output$ui.id_admin3 <- renderUI({
    a3 <- as.data.frame(choix_Admin) %>%
      filter(province %in% input$id_Admin2) %>%
      select(localite)
    items3 <- unique(a3)
    selectizeInput(inputId = "id_Admin3", label = "Commune", choices = items3,width = "180px")
  }
  )
  
  output$ui.id_admin4 <- renderUI({
    a4 <- as.data.frame(choix_Admin) %>%
      filter(province %in% input$id_Admin2) %>%
      select(localite)
    items4 <- unique(a4)
    selectizeInput(inputId = "id_Admin4", label = "Localité", choices = items4,width = "180px")
  }
  )
  
  output$ui.lat <- renderUI({
    a5 <- as.data.frame(choix_Admin) %>%
      filter(localite %in% input$id_Admin4) %>%
      select(lat)
    items5 <- unique(a5)
    numericInput(inputId = "lat", label = "Latitude", value = items5[[1]][1],width = "180px")
    #selectizeInput(inputId = "lat", label = "Latitude", choices = items5[[1]][1])
  }
  )
  
  output$ui.long <- renderUI({
    a5 <- as.data.frame(choix_Admin) %>%
      filter(localite %in% input$id_Admin4) %>%
      select(long)
    items5 <- unique(a5)
    numericInput(inputId = "long", label = "Longitude", value = items5[[1]][1],width = "180px")
    #selectizeInput(inputId = "lat", label = "Latitude", choices = items5[[1]][1])
  }
  )
  
  choix <- read_sheet("https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994", sheet = "data")
  
  nb <- nrow(choix)
  input_list <- reactive({
    cc = paste(as.character(input$date1),input$time1)
    index = paste(input$id_Pays,nb, sep = "-")
    input_list <- list( index,
                        input$id_Cat, 
                        input$id_Inc, 
                        cc , 
                        input$id_Desc, 
                        input$id_Acteur, 
                        input$name, 
                        input$id_Touch, 
                        input$name1, 
                        input$nbr_mort_acteur, 
                        input$nbr_bless_acteur, 
                        input$nbr_mort_touch, 
                        input$nbr_bless_touch, 
                        input$nbr_mort_milit, 
                        input$nbr_bless_milit, 
                        input$nbr_pers_arret, 
                        input$nbr_pers_enlev, 
                        input$id_Pays,
                        input$name2, 
                        input$id_Admin1, 
                        input$id_Admin2, 
                        input$id_Admin3,
                        input$lat, 
                        input$long, 
                        input$other_location, 
                        input$id_Admin4, 
                        input$road, 
                        input$id_Lieu, 
                        input$Children_Affected, 
                        input$Refugees_IDPs_Affected, 
                        input$UN_Affected, 
                        input$Humanitarians_Affected, 
                        input$Officials_Institutions_Affected, 
                        input$Attack,
                        input$Indirect,
                        input$Drone, 
                        input$PBIED, 
                        input$VBIED, 
                        input$EEI, 
                        input$PBIED_Attempt, 
                        input$VBIED_Attempt, 
                        input$IED_Attempt, 
                        input$Road_Block, 
                        input$Ambush, 
                        input$Car_Jacking, 
                        input$Raid_Incursion, 
                        input$Livestock_Theft, 
                        input$Assassinat, 
                        input$Abduction_Kidnapping, 
                        input$Displacement, 
                        input$Harassment_ThreatsZakat, 
                        input$SGBV, 
                        input$Sighting, 
                        input$Ratissage_Patrouille, 
                        input$Accrochage, 
                        input$Aerial_Bombing, 
                        input$Arms_Cache, 
                        input$Reddition, 
                        input$Intra_Intercommunal_Violence, 
                        input$Comment)
    
    
    input_list
  })
  
  output$text <- renderText({ unlist(input_list()) })
  
  observeEvent(input$submit, {
    
    
    df <- unlist(input_list())
    
    df1 <- t(df)
    df2 <- as.data.frame(df1,stringsAsFactors=TRUE)
    
    
    output$verb <- renderPrint({df2})
    #li1 <- as.data.frame(li)
    
    
    sheet_append(data = df2,
                 ss = "https://docs.google.com/spreadsheets/d/1QBhX6EwU56f3P2w_F9ip9L1MttL2r26SVUdTROEjmTM/edit#gid=930629994",
                 sheet = "data")
    
  })
  

}

# Run the application 
shinyApp(ui = ui, server = server)
