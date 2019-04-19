import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { OnsenModule } from 'ngx-onsenui';
import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { DefaultPageComponent } from './default-page/default-page.component';
declare var ons:any;

@NgModule({
  declarations: [
    AppComponent,
    DefaultPageComponent
  ],
  entryComponents: [
    DefaultPageComponent
  ],
  schemas : [
    CUSTOM_ELEMENTS_SCHEMA
  ],
  imports: [
    BrowserModule,
    OnsenModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { 
  constructor(){
    ons.platform.select('android');
  }
}
