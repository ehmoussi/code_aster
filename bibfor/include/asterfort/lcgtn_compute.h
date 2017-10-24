
#include "asterf_types.h"
!
interface
    function lcgtn_compute(grvi,resi,rigi,elas, itemax, prec, m, dt, eps, phi, ep, ka, f, state, &
                  t,deps_t,dphi_t,deps_ka,dphi_ka) &
        result(iret)
        use lcgtn,         only: gtn_material
    
        aster_logical,intent(in)     :: grvi,resi,rigi,elas
        type(gtn_material),intent(in):: m
        integer,intent(in)           :: itemax
        real(kind=8),intent(in)      :: prec
        real(kind=8),intent(in)      :: dt
        real(kind=8),intent(in)      :: eps(:)
        real(kind=8),intent(in)      :: phi
        real(kind=8),intent(inout)   :: ep(:),ka,f
        integer,intent(inout)        :: state
        real(kind=8),intent(out)     :: t(:),deps_t(:,:),dphi_t(:),deps_ka(:),dphi_ka
        integer                      :: iret
    end function
end interface
