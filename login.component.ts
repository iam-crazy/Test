import { Component, OnInit, ViewChild } from '@angular/core';
import {
  FormGroup,
  FormControl,
  Validators,
  FormBuilder,
  NgForm
} from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';
import { UserDetils } from '../../../models/admin/user-detils';
import { SessionBehaviour } from '../../../@framework/session-behaviour';
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  validateForm: FormGroup;
  isSubmitted: boolean;
  validationError = '';
  constructor(
    private authService: AuthService,
    private router: Router,
    private sessionBehaviour: SessionBehaviour
  ) {
    this.validateForm = new FormGroup({
      userName: new FormControl('', [
        Validators.required,
        Validators.email,
        Validators.minLength(5)
      ]),
      password: new FormControl('', [
        Validators.required,
        Validators.minLength(5)
      ])
    });
  }
  onSubmit(value: UserDetils) {
    this.isSubmitted = true;
    if (this.validateForm.invalid) {
      return;
    }
    this.router.navigateByUrl('ContentSummary');
    // this.authService
    //   .loginWithEmail(value.userName, value.password)
    //   .then(result => {
    //     if (
    //       this.stringValidator(result) &&
    //       this.stringValidator(result.user) &&
    //       this.stringValidator(result.user.uid)
    //     ) {
    //       this.isSubmitted = true;
    //       this.router.navigateByUrl('Dashboard');
    //     } else {
    //       this.isSubmitted = false;
    //       value.password = '';
    //       this.validationError = 'Email id or password is invalid';
    //     }
    //   });
  }

  stringValidator(input: any) {
    let output = true;
    if (input === null) {
      output = false;
    } else if (input === '') {
      output = false;
    } else if (input === undefined) {
      output = false;
    }
    return output;
  }

  reset() {
    this.validateForm.reset();
  }
}
