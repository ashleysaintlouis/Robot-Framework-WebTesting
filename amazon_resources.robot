*** Settings ***
Library        SeleniumLibrary


*** Variables ***
${URL}        https://www.amazon.com.br
${NAV_PROGRESSIVE}   (//div[@id='nav-xshop'])[1] 
${NAV_LISTA}    (//ul[@class='nav-ul'])[1]
${BODY}    //body
${ELETRONICOS}   (//a[contains(text(),'Eletrônicos')])[1]
${TEXTO_HEADER_ELECTRONICS}    (//span[contains(text(),'Eletrônicos e Tecnologia')])[1]
${VENDA}    (//div[@class='nav-div'])[2]  

# ${MENU_ELECTRONIC}    (//div[@class='nav-div'])[10]
# ${CLICK_MENU}    (//a[contains(@class,'')][normalize-space()='Venda na Amazon'])[1]

# ${LISTAR_SUBMENU}    //div[@class='hmenu hmenu-visible']//section[1]//ul[1]
# ${VER_TUDO}    Ver tudo

*** Keywords ***
Abrir o navegador 
    Open Browser    browser=chrome
    Maximize Browser Window
    
            
Fechar o navegador 
    Capture Page Screenshot
    Close Browser

Acessar a home page do site Amazon.com.br
    Go To    url=${URL}
    Sleep    25s
Verificar se aparece a lista menu
    Wait Until Element Is Visible    locator=${NAV_PROGRESSIVE}
    Capture Element Screenshot    locator=${NAV_PROGRESSIVE}
    Get WebElement    locator=${NAV_PROGRESSIVE}

    Set Focus To Element    locator=${NAV_LISTA}
    FOR    ${i}    IN RANGE    1    15
        ${existe}=    Run Keyword And Return Status    Wait Until Element Is Visible   ${ELETRONICOS}
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
        IF    ${existe}
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
    
    # Element Should Be Visible    locator=(//span[@class='a-size-base-plus'][normalize-space()='${NOME_CATEGORIA}'])[1]
        

Digitar o nome de produto "${PRODUTO}" no campo de pesquisa
    Input Text    locator=twotabsearchtextbox    text=${PRODUTO}

Clicar no botão de pesquisa
    Click Element    locator=nav-search-submit-button

Verificar o resultado da pesquisa de está listando o produto "${PRODUTO}"
    Get Text    locator=(//span[normalize-space()='${PRODUTO}'])[1]

