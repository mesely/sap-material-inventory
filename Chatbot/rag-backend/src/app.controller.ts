import { Controller, Post, Body } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appSvc: AppService) {}

  @Post('ask')
  async ask(@Body('question') question: string) {
    return this.appSvc.processQuestion(question);
  }
}
