import { FloorBean } from '@agctemplate/server';
import { HashMap } from '@kit.ArkTS';

export class FloorRegistry {
  private static floorMap = new HashMap<string, WrappedBuilder<[FloorBean]>>();

  public static register(builderKey: string, builder: WrappedBuilder<[FloorBean]>) {
    FloorRegistry.floorMap.set(builderKey, builder)
  }

  public static get(builderKey: string): WrappedBuilder<[FloorBean]> {
    return FloorRegistry.floorMap.get(builderKey)
  }
}


