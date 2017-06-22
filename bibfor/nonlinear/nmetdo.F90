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

subroutine nmetdo(sdcriq)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    character(len=24) :: sdcriq
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! POUR CALCUL DE L'INDICATEUR D'ERREUR TEMPORELLE, ON VERIFIE QU'ON EST
! BIEN DANS LE CADRE DES MODELISATIONS HM SATUREES AVEC COMPORTEMENT
! MECANIQUE ELASTIQUE
!
! ----------------------------------------------------------------------
!
! IN  SDCRIQ : SD CRITERE QUALITE
!
! ----------------------------------------------------------------------
!
! DIMAKI = DIMENSION MAX DE LA LISTE DES RELATIONS KIT
    integer :: dimaki
    parameter (dimaki=9)
!
    integer :: nbocc, n1, n2, ii, jj, iocc
    integer :: idebut, iret
    aster_logical :: ellisq
    character(len=16) :: comp1, comel(dimaki), argii, argjj
    character(len=24) :: errthm
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATION
!
    errthm = sdcriq(1:19)//'.ERRT'
    call jeexin(errthm, iret)
    if (iret .eq. 0) goto 999
!
! --- INDICATEUR D'ERREUR EN TEMPS -> ON VERIFIE QUE C'EST POSSIBLE
!
    call getfac('COMPORTEMENT', nbocc)
!
    if (nbocc .eq. 0) then
        call utmess('F', 'INDICATEUR_25')
    else
        do 10 iocc = 1, nbocc
            call getvtx('COMPORTEMENT', 'RELATION', iocc=iocc, scal=comp1, nbret=n1)
            if (comp1(1:6) .eq. 'KIT_HM') then
                call getvtx('COMPORTEMENT', 'RELATION_KIT', iocc=iocc, nbval=dimaki,&
                            vect=comel(1), nbret=n2)
                if (n2 .eq. 0) then
                    ASSERT(.false.)
                else if (n2.gt.dimaki) then
                    ASSERT(.false.)
                else
                    ellisq = .false.
                    do 101 ii = 1, n2
                        argii = comel(ii)
                        if ((argii(1:4).eq.'ELAS') .or. (argii(1:9) .eq.'LIQU_SATU')) then
                            idebut = ii + 1
                            do 102 jj = idebut, n2
                                argjj = comel(jj)
                                if ((argjj(1:4).eq.'ELAS') .or. (argjj(1:9).eq.'LIQU_SATU')) then
                                    ellisq = .true.
                                endif
102                         continue
                        endif
101                 continue
                endif
            endif
 10     continue
    endif
!
    if (.not.ellisq) then
        call utmess('F', 'INDICATEUR_23')
    endif
!
999 continue
!
    call jedema()
!
end subroutine
