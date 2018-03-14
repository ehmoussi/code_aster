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

subroutine cucpes(deficu, resocu, jsecmb, neq, nbliac_new)
!
!
    implicit     none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/calatm.h"
#include "asterfort/cudisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: deficu, resocu
    integer :: jsecmb, neq, nbliac_new
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DU SECOND MEMBRE POUR LE CONTACT -E_N.[Ac]T.{JEU}
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  JSECMB : ADRESSE VERS LE SECOND MEMBRE
!
!
!
!
    real(kind=8) :: jeuini, coefpn, lambdc
    integer :: iliai
    character(len=19) :: mu
    integer :: jmu
    character(len=24) :: apcoef, apddl, appoin
    integer :: japcoe, japddl, japptr
    character(len=24) :: coefpe
    integer :: jcoef_pena
    character(len=24) :: jeux
    integer :: jjeux
    integer :: nbliai, i
    integer :: nbddl, jdecal
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATION DES VARIABLES
!
    nbliai = cudisi(deficu,'NNOCU')
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = deficu(1:16)//'.POINOE'
    apddl = resocu(1:14)//'.APDDL'
    apcoef = resocu(1:14)//'.APCOEF'
!   Attention, on attend ici le jeu sans correction du contact
!   i.e. jeu le plus actuel possible par rapport à ce que l'on sait calculer
    jeux = resocu(1:14)//'.APJEU'
    coefpe = resocu(1:14)//'.COEFPE'
    mu = resocu(1:14)//'.MU'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(coefpe, 'L', jcoef_pena)
    call jeveuo(mu, 'E', jmu)
!
! --- INITIALISATION DES MU
! --- OK ON LAISSE TEL QUEL
!
    do iliai = 1, nbliai
        zr(jmu +iliai-1) = 0.d0
        zr(jmu+3*nbliai+iliai-1) = 0.d0
    end do
!
! --- RAZ VECTEUR SECMB
    do i=1,neq
        zr(jsecmb-1+i) = 0.d0
    end do
!
! --- CALCUL DES FORCES DE CONTACT
!
    nbliac_new = 0
    do iliai = 1, nbliai
        jeuini = zr(jjeux-1+iliai)
        coefpn = zr(jcoef_pena)
        if (jeuini .lt. 0.d0) then
            jdecal = zi(japptr+iliai-1)
            nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
            lambdc = -jeuini*coefpn
            nbliac_new = nbliac_new + 1
            zr(jmu+nbliac_new-1) = lambdc
            call calatm(neq, nbddl, lambdc, zr(japcoe+jdecal), zi(japddl+ jdecal),&
                        zr(jsecmb))
        endif
    end do
    write(6,*)'PENALISATION - NOMBRE LIAISONS ACTIVES : ', nbliac_new
!
    call jedema()
!
end subroutine
