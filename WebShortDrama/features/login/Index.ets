import { LoginAPI } from '@agctemplate/common';
import { container } from '@agctemplate/utils';
import { LoginManager } from './src/main/ets/LoginManager';

container.register(LoginAPI, {
  value: new LoginManager()
});
