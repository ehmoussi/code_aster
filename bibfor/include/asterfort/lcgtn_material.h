
#include "asterf_types.h"
!
interface
    function lcgtn_material(fami,kpg,ksp,imate,resi,grvi) result(mat)
        use lcgtn,         only: gtn_material
        
        aster_logical, intent(in) :: grvi,resi
        character(len=*),intent(in) :: fami
        integer,intent(in) :: imate, kpg, ksp
        type(gtn_material) :: mat 
    end function
end interface
