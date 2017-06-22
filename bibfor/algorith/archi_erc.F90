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

subroutine archi_erc(result,ifreq,matmas,obsdim,vecterc,freq,eval,cout_fon,cout_uv)
!
!
    implicit none
! ----------------------------------------------------------------------
!
!  ROUTINE LIEE A L'OPERATEUR CALC_ERC_DYN
!
!  ROUTINE FAISANT L'ARCHIVAGE DES RESULTATS DE LA RESOLUTION DE
! ----------------------------------------------------------------------
! IN  : RESUL      : NOM DU CONCEPT RESULTAT
! IN  : I_FREQ     : NUMERO D'ORDRE DE LA MESURE ASSOCIE A LA FREQ EN COURS
! IN  : MATMAS     : NOM DE LA MATRICE DE MASSE
! IN  : OBSDIM     : TABLEAU DONNANT LES INFORMATIONS DIMENSIONNELLES DE LA
!                    MATRICE D'OBSERVATION (DIM_FILE,DIM_COLONNE,NOMBRE_DE_
!                    VALEURS_NONNULLES)
! IN  : VECT_ERC   : VECTEUR SOLUTION ASSOCIE AU PB MATRICIEL D'ERC
! IN  : FREQ       : FREQUENCE DU PAS COURANT
! IN  : EVAL       : FLAG DETERMINANT SI ON A CALCULE LA FONCTIONNELLE
! IN  : OMEGA      : PULSATION ASSOCIEE A LA FREQUENCE EN COURS
! IN : COUT_FON    : VALEUR DE LA FONCTION COUT 
! IN : TERME_UV    : PART DE LA VALEUR DE LA FONCTION COUT ASSOCIE AUX CHAMPS D'ERR 
! ----------------------------------------------------------------------!
! ----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/vtcrem.h"
#include "asterfort/rsnoch.h"
#include "asterfort/jelibe.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
    character(len=8),intent(in) :: result,matmas
    character(len=19) :: chamno
    integer,intent(in) :: ifreq,obsdim(3)
    integer :: iret,lvale,ii,lfrqar,lomeg2,lfonct
    real(kind=8),intent(in) :: vecterc(*),freq,cout_fon,cout_uv
    real(kind=8) :: deuxpi
    aster_logical,intent(in) :: eval
!    
    deuxpi = r8depi()

       call rsexch(' ', result, 'DEPL', 2*(ifreq-1)+1, chamno,iret)
       if (iret .eq. 0) then
! --- LE CHAMPS EXISTE DEJA ALORS IL Y A UN PBLM, MESSAGE - D'ALARME
                call utmess('A', 'ALGORITH2_64', sk=chamno)
       else if (iret .eq. 100) then
!       --- LE CHAMPS N'EXISTE PAS ET IL EST POSSIBLE DE LE CREER
                call vtcrem(chamno, matmas, 'G', 'R')
!         --- CREATION D'UN CHAM_NO S'APPUYANT SUR LA NUMEROTATION
!           - DE LA MATRICE ASSEMBLEE DE MASSE
!
        else
!       --- SI IL N'EST PAS POSSIBLE DE CREER LE CHAMP, ERR. FATALE
                call utmess('F', 'ALGORITH2_65')
        endif
! --- --- RECOPIE DANS L'OBJET RESULTAT
        call jeveuo(chamno//'.VALE', 'E', lvale)
        do ii = 1, obsdim(2)
            zr(lvale-1+ii) = vecterc(obsdim(2)+ii)
        end do
        call rsnoch(result, 'DEPL', 2*(ifreq-1)+1)
        call jelibe(chamno//'.VALE')
! --- --- COPIE DE LA FREQUENCE D'ARCHIVAGE
        call rsadpa(result, 'E', 1, 'FREQ', 2*(ifreq-1)+1,0, sjv=lfrqar)
        zr(lfrqar) = freq
        call rsadpa(result, 'E', 1, 'OMEGA2', 2*(ifreq-1)+1,0, sjv=lomeg2)
        zr(lomeg2) = (deuxpi*freq)**2
!
! --- --- ARCHIVAGE DES RESULTATS SUR BASE PHYSIQUE (champ d'erreur u-v)
!
       call rsexch(' ', result, 'DEPL', 2*(ifreq-1)+2, chamno,iret)
       if (iret .eq. 0) then
! --- LE CHAMPS EXISTE DEJA ALORS IL Y A UN PBLM, MESSAGE - D'ALARME
                call utmess('A', 'ALGORITH2_64', sk=chamno)
       else if (iret .eq. 100) then
!       --- LE CHAMPS N'EXISTE PAS ET IL EST POSSIBLE DE LE CREER
                call vtcrem(chamno, matmas, 'G', 'R')
!         --- CREATION D'UN CHAM_NO S'APPUYANT SUR LA NUMEROTATION
!           - DE LA MATRICE ASSEMBLEE DE MASSE
!
        else
!       --- SI IL N'EST PAS POSSIBLE DE CREER LE CHAMP, ERR. FATALE
                call utmess('F', 'ALGORITH2_65')
        endif
! --- --- RECOPIE DANS L'OBJET RESULTAT
        call jeveuo(chamno//'.VALE', 'E', lvale)
        do ii = 1, obsdim(2)
            zr(lvale-1+ii) = vecterc(ii)
        end do
        call rsnoch(result, 'DEPL', 2*(ifreq-1)+2)
        call jelibe(chamno//'.VALE')
! --- --- COPIE DE LA FREQUENCE D'ARCHIVAGE
        call rsadpa(result, 'E', 1, 'FREQ', 2*(ifreq-1)+2,0, sjv=lfrqar)
        zr(lfrqar) = freq
        call rsadpa(result, 'E', 1, 'OMEGA2', 2*(ifreq-1)+2,0, sjv=lomeg2)
        zr(lomeg2) = (deuxpi*freq)**2
! --- --- ON ARCHIVE LA FONCTIONNELLE ERC SI DEMANDE, SINON ELLE VAUT ZERO
        if (eval) then
!       on archive la valeur de la fonction cout sur la parametre dedie ERC_EVAL_FONC
           call rsadpa(result, 'E', 1, 'ERC_EVAL_FONC', 2*(ifreq-1)+1,0, sjv=lfonct)
           zr(lfonct) = cout_fon
           call rsadpa(result, 'E', 1, 'ERC_EVAL_FONC', 2*(ifreq-1)+2,0, sjv=lfonct)
           zr(lfonct) = cout_uv
        else 
           call rsadpa(result, 'E', 1, 'ERC_EVAL_FONC', 2*(ifreq-1)+1,0, sjv=lfonct)
           zr(lfonct) = 0.d0
           call rsadpa(result, 'E', 1, 'ERC_EVAL_FONC', 2*(ifreq-1)+2,0, sjv=lfonct)
           zr(lfonct) = 0.d0

        end if


end subroutine
