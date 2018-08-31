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
#include "asterfort/compute_ineq_conditions_vector.h"
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
    integer :: iliac
    character(len=19) :: mu
    integer :: jmu
    character(len=24) :: apcoef, apddl, appoin
    integer :: japcoe, japddl, japptr
    character(len=24) :: coefpe
    integer :: jcoef_pena
    character(len=24) :: jeux
    integer :: jjeux
    integer :: nbliai
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATION DES VARIABLES
!
    nbliai = cudisi(deficu, 'NNOCU')
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = deficu(1:16)//'.POINOE'
    apddl = resocu(1:14)//'.APDDL'
    apcoef = resocu(1:14)//'.APCOEF'
!   Attention, on attend ici le jeu sans correction du contact
!   i.e. jeu le plus actuel possible par rapport à ce que l'on sait calculer
    jeux = resocu(1:14)//'.APJEU'
    coefpe = deficu(1:16)//'.COEFPE'
    mu = resocu(1:14)//'.MU'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(coefpe, 'L', jcoef_pena)
    call jeveuo(mu, 'E', jmu)
!
! --- RAZ VECTEUR SECMB
    zr(jsecmb:jsecmb-1+neq) = 0.d0
    
    call compute_ineq_conditions_vector(jsecmb, nbliai      , neq,   &
                                        japptr, japddl      , japcoe,&
                                        jjeux , jcoef_pena-1, jmu,   &
                                        1     , 1           , iliac  )
    
    nbliac_new = iliac - 1
!
    call jedema()
!
end subroutine
