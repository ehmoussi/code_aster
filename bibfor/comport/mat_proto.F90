! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine mat_proto(fami, kpg, ksp, poum, imate, itface, nprops, props)
!     but: Calculer les coef. materiau pour l'interface umat
!       in   fami    : famille de point de gauss (rigi,mass,...)
!       in   kpg,ksp : numero du (sous)point de gauss
!       in   poum    : '+' /'-'
!       in   nprops  : en entree : dimension du tableau props
!       in   itface  : nom de l'interface de prototypage
!       out  nprops  : en sortie : nombre de coefficients recuperes dans props
!            props(*): coeficients du materiau
! ======================================================================
    implicit none

#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcadlv.h"
#include "asterfort/assert.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
#include "asterfort/get_meta_phasis.h"
#include "asterfort/get_meta_id.h"

    character(len=*), intent(in) :: fami
    integer, intent(in)          :: kpg
    integer, intent(in)          :: ksp
    character(len=1), intent(in) :: poum
    integer, intent(in)          :: imate
    character(len=*), intent(in) :: itface
    integer, intent(inout)       :: nprops
    real(kind=8), intent(out)    :: props(*)
!----------------------------------------------------------------------------

    integer      :: i, jadr,icodre, ncoef
    real(kind=8) :: rundef

!
    real(kind=8) :: phase(5), zalpha
    integer     :: meta_id, nb_phasis
    character(len=16) :: elas_keyword
!----------------------------------------------------------------------------
    rundef=r8nnem()

!   -- Seulement UMAT et MFRONT
    ASSERT(itface.eq.'UMAT' .or. itface.eq.'MFRONT')

!   -- mise a "undef" du tableau resultat :
    ASSERT(nprops.gt.0 .and. nprops.le.197)
    call r8inir(nprops, rundef, props, 1)

!   -- recuperation des valeurs et recopie dans props :
    call rccoma(imate, 'ELAS_META', 0, elas_keyword, icodre)
    
!    
    if (icodre.eq.0) then
        call get_meta_id(meta_id, nb_phasis)
        call get_meta_phasis(fami     , poum  , kpg   , ksp , meta_id,&
                             nb_phasis, phase, zcold_ = zalpha)
!
        call rcadlv(fami, kpg, ksp, poum, imate, ' ', itface, &
                    'LISTE_COEF',1, ['META'], [zalpha], jadr, ncoef, icodre, 1)
    else
        call rcadlv(fami, kpg, ksp, poum, imate, ' ', itface,  &
                    'LISTE_COEF',0, [' '], [0.d0], jadr, ncoef, icodre, 1)       
    endif
!
    if (ncoef.le.nprops) then
        do i=1,ncoef
            props(i)=zr(jadr-1+i)
        enddo
        nprops=ncoef
    else
        nprops=-ncoef
        ASSERT(.false.)
    endif

    end
