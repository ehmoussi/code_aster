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

subroutine uttcpr(nommes, nbv, temps)
    implicit none
! person_in_charge: jacques.pellet at edf.fr
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
!
    character(len=*) :: nommes
    integer :: nbv
    real(kind=8) :: temps(nbv)
! ----------------------------------------------------------------------
! ROUTINE DE MESURE DU TEMPS CPU.
! BUT : RECUPERER LES VALEURS D'UNE MESURE DE TEMPS
!
! IN  NOMMES    : NOM IDENTIFIANT LA MESURE
!
! IN  NBV       : DIMENSION DU TABLEAU TEMPS
! OUT TEMPS     : TABLEAU CONTENANT LES MESURES
! ----------------------------------------------------------------------
!    TEMPS(1) TEMPS RESTANT EN SECONDES
!    TEMPS(2) NOMBRE D'APPEL A DEBUT/FIN
!    TEMPS(3) TEMPS CPU TOTAL
!    TEMPS(4) TEMPS ELAPSED MOYEN
!    TEMPS(5) TEMPS CPU USER TOTAL
!    TEMPS(6) TEMPS CPU SYSTEME
!    TEMPS(7) TEMPS ELAPSED
!
! RQUE : LES VALEURS STOCKEES SONT ACCUMUEES VIA UTTCPU
! ----------------------------------------------------------------------
    aster_logical :: ljev
    integer :: indi, jvalms, k
!
!
!     -- COMMONS POUR MESURE DE TEMPS :
    integer :: mtpniv, mtpsta, indmax
    parameter (indmax=5)
    character(len=80) :: snolon(indmax)
    real(kind=8) :: valmes(indmax*7), valmei(indmax*7)
    common /mestp1/ mtpniv,mtpsta
    common /mestp2/ snolon
    common /mestp3/ valmes,valmei
! ----------------------------------------------------------------------
!
!     1. CALCUL DE INDI ET LJEV :
!     -------------------------------
!     -- POUR CERTAINES MESURES, ON NE PEUT PAS FAIRE DE JEVEUX :
!        ON GARDE ALORS LES INFOS DANS LES COMMON MESTPX
    if (nommes .eq. 'CPU.MEMD.1') then
        indi=1
    else if (nommes.eq.'CPU.MEMD.2') then
        indi=2
    else
        ljev=.true.
        call jenonu(jexnom('&&UTTCPU.NOMMES', nommes), indi)
        if (indi .eq. 0) goto 999
        goto 9998
    endif
    ASSERT(indi.le.indmax)
    ljev=.false.
!
!
!     2. RECUPERATION DES TEMPS :
!     -------------------------------
9998 continue
    if (ljev) then
        call jeveuo('&&UTTCPU.VALMES', 'L', jvalms)
        do k = 1, nbv
            temps(k)= zr(jvalms-1+7*(indi-1)+k)
        end do
    else
        do k = 1, nbv
            temps(k)= valmes(7*(indi-1)+k)
        end do
    endif
!
!
999 continue
end subroutine
