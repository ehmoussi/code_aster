
#include "asterf_types.h"
!
interface
    subroutine lcgrad_bis(resi, rigi, sig, apg, lag, grad, aldc,&
                  r, c, deps_sig,dphi_sig,deps_a,dphi_a, sief, dsde)
        aster_logical :: resi, rigi
        real(kind=8),intent(in) :: sig(:), apg, lag, grad(:), aldc, r, c
        real(kind=8),intent(in) :: deps_sig(:,:),dphi_sig(:),deps_a(:),dphi_a
        real(kind=8)            :: sief(*), dsde(:,:)
    end subroutine lcgrad_bis
end interface
