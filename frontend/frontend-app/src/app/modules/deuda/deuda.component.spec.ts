import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeudaComponent } from './deuda.component';

describe('DeudaComponent', () => {
  let component: DeudaComponent;
  let fixture: ComponentFixture<DeudaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DeudaComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DeudaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
