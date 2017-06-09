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

subroutine tresu_obj(nomobj, type, tbtxt, refi, refr,&
                     epsi, crit, llab, ssigne, ignore,&
                     compare)
    implicit none
#include "asterf_types.h"
#include "asterfort/jeexin.h"
#include "asterfort/tstobj.h"
#include "asterfort/tresu_print.h"
#include "asterfort/utmess.h"
    character(len=24), intent(in) :: nomobj
    character(len=*), intent(in) :: type
    character(len=16), intent(in) :: tbtxt(2)
    integer, intent(in) :: refi
    real(kind=8), intent(in) :: refr
    real(kind=8), intent(in) :: epsi
    character(len=*), intent(in) :: crit
    aster_logical, intent(in) :: llab
    character(len=*), intent(in) :: ssigne
    aster_logical, intent(in), optional :: ignore
    real(kind=8), intent(in), optional :: compare
!     ENTREES:
!        NOMOBJ : NOM DE L'OBJET JEVEUX QUE L'ON VEUT TESTER
!        TYPE   : TYPE DE VALEUR A TESTER :
!                  /'RESUME' : ENTIER QUI RESUME L'OBJET
!                  /'S_I'    : SOMME ENTIERE DE L'OBJET
!                  /'S_R'    : SOMME REELLE DE L'OBJET
!        TBTXT  : (1) : REFERENCE
!                 (2) : LEGENDE
!        REFI   : VALEUR ENTIERE ATTENDUE POUR L'OBJET
!        REFR   : VALEUR REELLE ATTENDUE POUR L'OBJET
!        CRIT   : 'RELATIF' OU 'ABSOLU'(PRECISION RELATIVE OU ABSOLUE).
!        EPSI   : PRECISION ESPEREE
!        LLAB   : FLAG D IMPRESSION DES LABELS
!     SORTIES:
!      LISTING ...
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
    character(len=3) :: tysc
    real(kind=8) :: sommr
    integer :: resume, sommi, lonuti, lonmax, ni, iret, iret2
    aster_logical :: skip
    real(kind=8) :: ordgrd
!
    skip = .false.
    if (present(ignore)) then
        skip = ignore
    endif
!
    ordgrd = 1.d0
    if (present(compare)) then
        ordgrd = compare
    endif
!
    call tstobj(nomobj, 'NON', resume, sommi, sommr,&
                lonuti, lonmax, tysc, iret, ni)
!
    if (iret .eq. 0) then
        if (type .eq. 'RESUME') then
            call tresu_print(tbtxt(1), tbtxt(2), llab, 1, crit,&
                             epsi, ssigne, refi=[refi], vali=resume)
        else if (type.eq.'I') then
            call tresu_print(tbtxt(1), tbtxt(2), llab, 1, crit,&
                             epsi, ssigne, refi=[refi], vali=sommi)
        else if (type.eq.'R') then
            call tresu_print(tbtxt(1), tbtxt(2), llab, 1, crit,&
                             epsi, ssigne, refr=[refr], valr=sommr, ignore=skip,&
                             compare=ordgrd)
        endif
    else
        call jeexin(nomobj, iret2)
        if (iret2 .le. 0) then
            call utmess('F', 'CALCULEL6_86', sk=nomobj)
        else
            call utmess('F', 'CALCULEL6_87', sk=nomobj)
        endif
    endif
!
end subroutine
