! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdcae(sddisc, iterat, typdec, nbrpas, ratio,&
                  optdec, retdec)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/nmacex.h"
#include "asterfort/nmlerr.h"
#include "asterfort/utmess.h"
!
character(len=19) :: sddisc
integer :: iterat, nbrpas, retdec
real(kind=8) :: ratio
character(len=16) :: optdec
character(len=4) :: typdec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! PARAMETRES DE DECOUPE - EXTRAPOLATION DES RESIDUS
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! OUT RATIO  : RATIO DU PREMIER PAS DE TEMPS
! OUT TYPDEC : TYPE DE DECOUPE
!              'SUBD' - SUBDIVISION PAR UN NOMBRE DE PAS DONNE
!              'DELT' - SUBDIVISION PAR UN INCREMENT DONNE
! OUT NBRPAS : NOMBRE DE PAS DE TEMPS
! OUT OPTDEC : OPTION DE DECOUPE
!     'UNIFORME'   - DECOUPE REGULIERE ET UNIFORME
!     'PROGRESSIF' - DECOUPE EN DEUX ZONES, UN PAS LONG+ UNE SERIE
!                    DE PAS UNIFORMES
!     'DEGRESSIF'  - DECOUPE EN DEUX ZONES, UNE SERIE DE PAS
!                    UNIFORMES + UN PAS LONG
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
!
!
!
!
    real(kind=8) :: un
    aster_logical :: lextra
    real(kind=8) :: valext(4)
    real(kind=8) :: xxbb, xa0, xa1, xdet, cresi, ciblen
    real(kind=8) :: r8bid
    integer :: mniter, mxiter
!
! ----------------------------------------------------------------------
!
    un = 1.d0
    retdec = 0
    ratio = 0.d0
    nbrpas = -1
    optdec = 'UNIFORME'
    typdec = ' '
!
! --- LECTURE DES INFOS SUR LES CONVERGENCES
!
    call nmlerr(sddisc, 'L', 'MNITER', r8bid, mniter)
    call nmlerr(sddisc, 'L', 'MXITER', r8bid, mxiter)
!
! --- EXTRAPOLATION LINEAIRE DES RESIDUS
!
    call nmacex(sddisc, iterat, lextra, valext)
    xa0 = valext(1)
    xa1 = valext(2)
    xdet = valext(3)
    cresi = valext(4)
!
! --- CALCUL DU RATIO
!
    if (.not.lextra) then
        call utmess('I', 'EXTRAPOLATION_12')
        nbrpas = 4
        retdec = 1
        ratio  = 1.d0
        optdec = 'UNIFORME'
        typdec = 'SUBD'
    else
        call utmess('I', 'EXTRAPOLATION_11')
        nbrpas = 4
        ciblen = (xa0 + xa1*log(cresi) )/xdet
        if (xdet .le. r8prem()) then
            ratio = 24.0d0/((3.0d0*nbrpas+un)**2 - un)
        else
            if ((ciblen*1.20d0) .lt. mniter) then
                ratio = 24.0d0/((3.0d0*nbrpas+un)**2 - un)
            else
                if (xa1 .le. r8prem()) then
                    ratio = 24.0d0/((3.0d0*nbrpas+un)**2 - un)
                else
                    if ((ciblen-mxiter) .le. (-10.0d0*xa1/xdet)) then
                        ratio = exp( (ciblen-mxiter)*xdet/xa1 )
                    else
                        ratio = exp( -10.0d0 )
                    endif
                    ratio = 0.48485d0*ratio
                    xxbb = ( -un + (un+24.0d0/ratio)**0.5d0 )/3.0d0
                    if (xxbb .lt. 2.0d0) then
                        nbrpas = 2
                        ratio = 0.5d0
                    else
                        nbrpas = nint( xxbb )
                    endif
                endif
            endif
        endif
        retdec = 1
        optdec = 'PROGRESSIF'
        typdec = 'SUBD'
    endif
!
end subroutine
