
# ![][image_ref_h9dx8aza] Phonebook Application

**Phonebook application** that uses **Flutter SDK** via Android Studio IDE as a front-end. With a back-end of Node.js REST API it uses Express, Mongoose and MongoDB Atlas. It features **C**reate, **R**ead, **U**pdate and **D**elete. It has **no Authentication**.

## Screens

A preview of the application's screen.

>#### 1.  Open App -> Main Screen
>
>![](Screenshots/Splash%20and%20ico%20to%20Main.gif)

>#### 2. Main Screen Features:
>**Dialog**, **Dismissible**, **Refresh indicator**, **Delete**
>
>![](Screenshots/On%20press%20Dialog.gif)
>![](Screenshots/Dismissibles.gif)
>![](Screenshots/Refresh%20Indicator.gif)
>![](Screenshots/Deleting.gif)

>#### 3. Main Screen -> Create Screen
>![](Screenshots/Maint%20to%20Create.gif)

>#### 4. Create Screen Features: 
>**Name Forms** (with auto caps, and Next) and **Dynamic Forms** for Phone numbers (Increment/Decrement), **Clear specific Form**, and **Refresh Forms** to empty
>
>![](Screenshots/Supply%20Form(auto%20Caps%20and%20Next),%20Add%20Phonennums.gif)
>![](Screenshots/CR_Decrement%20Num.gif)
>![](Screenshots/Clear%20Indiv%20Form.gif)
>![](Screenshots/CR_Refresh%20Forms.gif)

>#### 5. Confirm Contact Creation 
>
>![](Screenshots/CR_Confirmation%20Dialog.gif)
>![](Screenshots/CR_Contact%20Created.gif)

>#### 6. Main Screen -> Edit Screen
>
>![](Screenshots/UP_Goto%20Edit%20Screen.gif)

>#### 7. Edit Screen Features:
>**Initialize Number**, **Refresh Form**, **Edit**(Name, Number), **Add** Numbers
>
>![](Screenshots/UP_Initialize%20numebr.gif)
>![](Screenshots/UP_Refresh%20Form.gif)
>![](Screenshots/UP_Edit%20Name.gif)
>![](Screenshots/UP_Edit%20Number.gif)
>![](Screenshots/UP_Add%20Number.gif)
>![](Screenshots/UP_Contact%20Updated.gif)

>#### 8. Edit Screen OnBack 
>
>![](Screenshots/UP_Back%20Dialog_.gif)
>![](Screenshots/UP_Back%20Dialog_Confirm.gif)
>


[image_ref_h9dx8aza]: data:image/png;base64,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
