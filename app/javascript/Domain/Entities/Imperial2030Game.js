import AbstractImperialGame from './AbstractImperialGame';

import Nation from './Nations/Nation';
import { Nation2030 as NationEnum } from '../constants';

export default class Imperial2030Game extends AbstractImperialGame {
  static get classId() {
    return 'imperial2030';
  }

  static get RussiaId() {
    return NationEnum.RU;
  }
  static get ChinaId() {
    return NationEnum.CN;
  }
  static get IndiaId() {
    return NationEnum.IN;
  }
  static get BrazilId() {
    return NationEnum.BR;
  }
  static get UnitedStatesId() {
    return NationEnum.US;
  }
  static get EuropeanUnionId() {
    return NationEnum.EU;
  }

  constructor(id) {
    const nations = new Map();
    nations.set(Imperial2030Game.RussiaId, new Nation(Imperial2030Game.RussiaId));
    nations.set(Imperial2030Game.ChinaId, new Nation(Imperial2030Game.ChinaId));
    nations.set(Imperial2030Game.IndiaId, new Nation(Imperial2030Game.IndiaId));
    nations.set(Imperial2030Game.BrazilId, new Nation(Imperial2030Game.BrazilId));
    nations.set(Imperial2030Game.UnitedStatesId, new Nation(Imperial2030Game.UnitedStatesId));
    nations.set(Imperial2030Game.EuropeanUnionId, new Nation(Imperial2030Game.EuropeanUnionId));

    const nationOrder = new Array(6);
    nationOrder[0] = nations.get(Imperial2030Game.RussiaId);
    nationOrder[1] = nations.get(Imperial2030Game.ChinaId);
    nationOrder[2] = nations.get(Imperial2030Game.IndiaId);
    nationOrder[3] = nations.get(Imperial2030Game.BrazilId);
    nationOrder[4] = nations.get(Imperial2030Game.UnitedStatesId);
    nationOrder[5] = nations.get(Imperial2030Game.EuropeanUnionId);

    super(id, nations, nationOrder);
  }

  get Russia() {
    return this.nationIdToEntity(Imperial2030Game.RussiaId);
  }
  get China() {
    return this.nationIdToEntity(Imperial2030Game.ChinaId);
  }
  get India() {
    return this.nationIdToEntity(Imperial2030Game.IndiaId);
  }
  get Brazil() {
    return this.nationIdToEntity(Imperial2030Game.BrazilId);
  }
  get UnitedStates() {
    return this.nationIdToEntity(Imperial2030Game.UnitedStatesId);
  }
  get EuropeanUnion() {
    return this.nationIdToEntity(Imperial2030Game.EuropeanUnionId);
  }
}
