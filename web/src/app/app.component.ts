import { Component } from '@angular/core';
import { DefaultPageComponent } from './default-page/default-page.component';

@Component({
  selector: 'app',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'webport';
  page = DefaultPageComponent;

  constructor(){
    
  }
}
