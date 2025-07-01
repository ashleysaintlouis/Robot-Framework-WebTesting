*** Settings ***
Library        SeleniumLibrary


*** Variables ***
${URL}        https://www.amazon.com.br
${NAV_PROGRESSIVE}   (//div[@id='nav-xshop'])[1] 
${NAV_LISTA}    (//ul[@class='nav-ul'])[1]
${BODY}    //body
${ELETRONICOS}   (//a[contains(text(),'Eletrônicos')])[1]
${TEXTO_HEADER_ELECTRONICS}    (//span[contains(text(),'Eletrônicos e Tecnologia')])[1]
${PRODUTO_ELEC}    (//a[@class='a-link-normal s-no-outline'])[7]
${BOTAO_ADD_CAR}    //input[@id='add-to-cart-button']



*** Keywords ***
Abrir o navegador 
    Open Browser    browser=chrome
    Maximize Browser Window
    
            
Fechar o navegador 
    Capture Page Screenshot
    Close Browser

Acessar a home page do site Amazon.com.br
    Go To    url=${URL}
    Sleep    5s
Verificar se aparece a lista menu
    Wait Until Element Is Visible    locator=${NAV_PROGRESSIVE}
    Capture Element Screenshot    locator=${NAV_PROGRESSIVE}
    Get WebElement    locator=${NAV_PROGRESSIVE}

    Set Focus To Element    locator=${NAV_LISTA}
    FOR    ${i}    IN RANGE    1    30
        ${existe}=    Run Keyword And Return Status    Element Should Not Be Visible   ${ELETRONICOS}
        IF    ${existe}
            Log    Elemento encontrado após ${i} TABs
            Capture Element Screenshot    locator=${ELETRONICOS}
            Click Element    ${ELETRONICOS}
            BREAK
        END
        Press Keys    ${BODY}    \\09
        Sleep    2s
    END

Verificar se aparece a frase "${FRASE}"
    Wait Until Page Contains    text=Eletrônicos e Tecnologia
    Sleep    2S
    Wait Until Element Is Visible    locator=${TEXTO_HEADER_ELECTRONICS}


Verificar se o título da página fica "${TITULO}"
    Title Should Be    title=${TITULO}

Verificar se aparece a categoria "${NOME_CATEGORIA}"

    FOR    ${i}    IN RANGE    1    30
        ${existe}=    Run Keyword And Return Status    Element Should Be Visible    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]
        ${existe_not_visible}=    Run Keyword And Return Status    Element Should Not Be Visible    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]

        IF    ${existe} or ${existe_not_visible}
            Log    Elemento encontrado após ${i} TABs
            Capture Element Screenshot    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]
            Set Focus To Element    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]
            Execute JavaScript    document.activeElement.style.outline='2px solid red';
            # Click Element    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]
            BREAK
        END
        Press Keys    ${BODY}    \\09
        Execute JavaScript    document.activeElement.style.outline='2px solid red';
        Sleep    1s
    END
            

# Caso 02

Digitar o nome de produto "${PRODUTO}" no campo de pesquisa
    Input Text    locator=twotabsearchtextbox    text=${PRODUTO}

Clicar no botão de pesquisa
    Click Element    locator=nav-search-submit-button

Verificar o resultado da pesquisa de está listando o produto "${PRODUTO}"
    Get Text    locator=(//span[normalize-space()='${PRODUTO}'])[1]
    Capture Element Screenshot    locator=(//span[normalize-space()='${PRODUTO}'])[1]
    


# Caso 03
Adicionar o produto "${PRODUTO}" no carrinho
    Click Element    locator=(//span[normalize-space()='${PRODUTO}'])[1]
    ${Bota_add}=    Run Keyword And Return Status    Element Should Be Visible   locator=${BOTAO_ADD_CAR}
        ${Text_add}=    Run Keyword And Return Status    Element Should Be Visible    locator=//span[@id='submit.add-to-cart-announce']
    
    FOR    ${i}    IN RANGE    1    30
        IF    ${Bota_add} and ${Text_add}
            Log    Elemento encontrado após ${i} TABs
            Capture Element Screenshot    locator=${BOTAO_ADD_CAR}
            Click Element    locator=${BOTAO_ADD_CAR}
            BREAK
        END
        Press Keys    ${BODY}    \\09
        Sleep    2s
    END

    # ${Bota_add}=    Run Keyword And Return Status    Element Should Be Visible   locator=${BOTAO_ADD_CAR}
    # ${Text_add}=    Run Keyword And Return Status    Element Should Be Visible    locator=//span[@id='submit.add-to-cart-announce']

    # IF    ${Bota_add} and ${Text_add}
    #     Capture Element Screenshot    locator=${BOTAO_ADD_CAR}
    #     Click Element    locator=${BOTAO_ADD_CAR}
    # END
    # Sleep    2s

Verificar se o produto "Xbox Series S" foi adicionado com sucesso
    ${Text_Add}=    Run Keyword And Return Status    Element Should Be Visible    locator=(//h1[normalize-space()='Adicionado ao carrinho'])[1]
    ${Icon_Success}    Run Keyword And Return Status    Element Should Be Visible    locator=(//i[@class='a-icon a-icon-alert'])[4]

    IF    ${Text_Add} and ${Icon_Success}
        Capture Element Screenshot    locator=(//h1[normalize-space()='Adicionado ao carrinho'])[1]
    END



# Caso 04
Remover o produto "Xbox Series S" do carrinho
    Wait Until Element Is Visible    locator=//button[@data-action='a-stepper-decrement']
    Click Element    locator=//button[@data-action='a-stepper-decrement']
    Sleep    2s

Verificar se o carrinho fica vazio
    Get Text    Xbox Series S foi removido de Carrinho de compras.
    Sleep    2s
    Capture Page Screenshot

    

# Gherkin

Dado que estou na home page da Amazon.com.br
    Acessar a home page do site Amazon.com.br
Quando acessar o menu "Eletrônicos"
    Verificar se aparece a lista menu
Então o título da página deve ficar "Eletrônicos e Tecnologia | Amazon.com.br"
    Verificar se o título da página fica "Eletrônicos e Tecnologia | Amazon.com.br"
E o texto "Eletrônicos e Tecnologia" deve ser exibido na página
    Verificar se aparece a frase "Eletrônicos e Tecnologia"
E a categoria "Computadores e Informática" deve ser exibida na página
    Verificar se aparece a categoria "Computadores e Informática"
    Verificar se aparece a categoria "Tablets"

# E a categoria "Tablets" deve ser exibida na página
#     Verificar se aparece a categoria "Tablets"

# Caso 02

Quando pesquisar pelo produto "Xbox Series S"
    Digitar o nome de produto "Xbox Series S" no campo de pesquisa
Então o título da página deve ficar "Amazon.com.br : Xbox Series S"
    Clicar no botão de pesquisa
E um produto da linha "Xbox Series S" deve ser mostrado na página
    Verificar o resultado da pesquisa de está listando o produto "Xbox Series S"


# Caso 03

