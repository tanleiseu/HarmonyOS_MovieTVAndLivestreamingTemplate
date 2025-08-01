import { DramaInfo } from '@agctemplate/server';
import { DramaItemVM } from '../viewmodel/DramaItemVM';

export function mapDramaItem(drama: DramaInfo): DramaItemVM {
  let dramaItemVM: DramaItemVM = new DramaItemVM(
    drama
  )
  return dramaItemVM;
}