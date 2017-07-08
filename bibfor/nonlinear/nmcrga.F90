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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcrga(sderro)
!
implicit none
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
!
character(len=24) :: sderro
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD GESTION ALGO)
!
! CREATION DE LA SD
!
! ----------------------------------------------------------------------
!
! NB: LA SD S'APPELLE SDERRO
!
! IN  SDERRO : SD ERREUR
!
! ----------------------------------------------------------------------
!
    integer, parameter :: zeven = 34
! - Name of events
    character(len=16), parameter :: neven(zeven) = (/'ERRE_INTE','INTE_NPHY','DIVE_DEBO',&
                                                     'INTE_BORN',&
                                                     'ERRE_PILO','CONV_PILO','ERRE_FACS',&
                                                     'ERRE_FACT','ERRE_CTD1','ERRE_CTD2',&
                                                     'ERRE_TIMN','ERRE_TIMP','ERRE_EXCP',&
                                                     'ITER_MAXI',&
                                                     'DIVE_RESI','RESI_MAXR','RESI_MAXN',&
                                                     'CRIT_STAB','DIVE_FIXG','RESI_MAXI', &
                                                     'DIVE_FIXF','DIVE_FIXC','ERRE_CTCG',&
                                                     'ERRE_CTCF','ERRE_CTCC','DIVE_FROT',&
                                                     'DIVE_GEOM','DIVE_RELA','DIVE_MAXI',&
                                                     'DIVE_REFE','DIVE_COMP','DIVE_CTCC',&
                                                     'SOLV_ITMX','DIVE_HROM'/)
! - Return code (name)
    character(len=8), parameter :: ncret(zeven) = (/'LDC','LDC','LDC',&
                                                    'LDC',&
                                                    'PIL','PIL','FAC',&
                                                    'FAC','CTC','CTC',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'XXX','XXX','XXX',&
                                                    'RES','XXX'/)
! - Return code (value)
    integer, parameter :: vcret(zeven) = (/ 1 , 2, 3,&
                                            4 ,&
                                            1 , 2, 1,&
                                            2 , 1, 2,&
                                            99,99,99,&
                                            99,&
                                            99,99,99,&
                                            99,99,99,&
                                            99,99,99,&
                                            99,99,99,&
                                            99,99,99,&
                                            99,99,99,&
                                            1 ,99/)
!
! --- TYPE ET NIVEAU DE DECLENCHEMENT POSSIBLES DE L'EVENEMENT
! TROIS TYPES
! EVEN  : EVENEMENT A CARACTERE PUREMENT INFORMATIF
!          -> PEUT ETRE TRAITE SI UTILISATEUR LE DEMANDE DANS
!             DEFI_LIST_INST
! ERRI_ : EVENEMENT A TRAITER IMMEDIATEMENT SI ON VEUT CONTINUER
! ERRC_ : EVENEMENT A TRAITER A CONVERGENCE
! CONV_ : EVENEMENT A TRAITER POUR DETERMINER LA CONVERGENCE
!
    character(len=16), parameter :: teven(zeven) = (/'ERRI_NEWT','ERRC_NEWT','CONV_NEWT',&
                                                     'EVEN     ',&
                                                     'ERRI_NEWT','CONV_CALC','ERRI_NEWT',&
                                                     'ERRI_NEWT','ERRI_NEWT','ERRI_NEWT',&
                                                     'ERRI_CALC','ERRI_CALC','ERRI_CALC',&
                                                     'ERRI_NEWT',&
                                                     'EVEN     ','EVEN     ','EVEN     ',&
                                                     'EVEN     ','CONV_FIXE','EVEN     ',&
                                                     'CONV_FIXE','CONV_FIXE','ERRI_FIXE',&
                                                     'ERRI_FIXE','ERRI_FIXE','CONV_RESI',&
                                                     'CONV_NEWT','CONV_RESI','CONV_RESI',&
                                                     'CONV_RESI','CONV_RESI','CONV_NEWT',&
                                                     'ERRI_NEWT','CONV_FIXE'/)
!
! --- FONCTIONNALITE ACTIVE SI NECESSAIRE POUR CONVERGENCE
!
    character(len=24), parameter :: feven(zeven) = (/'         ', '         ','         ',&
                                                     '         ',&
                                                     '         ', 'PILOTAGE ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     '         ', '         ','         ',&
                                                     'LDLT_SP  ', '         '/)
!
! --- CODE DU MESSAGE A AFFICHER
!
    character(len=24), parameter :: meven(zeven) = (/&
            'MECANONLINE10_1 ','MECANONLINE10_24','                ',&
            'MECANONLINE10_25',&
            'MECANONLINE10_2 ','                ','MECANONLINE10_6 ',&
            'MECANONLINE10_6 ','MECANONLINE10_4 ','MECANONLINE10_4 ',&
            'MECANONLINE10_7 ','MECANONLINE10_5 ','MECANONLINE10_8 ',&
            'MECANONLINE10_3 ',&
            '                ','                ','                ',&
            'MECANONLINE10_20','                ','MECANONLINE10_26',&
            '                ','                ','MECANONLINE10_9 ',&
            'MECANONLINE10_10','MECANONLINE10_11','                ',&
            '                ','                ','                ',&
            '                ','                ','                ',&
            'MECANONLINE10_12','                '/)
!
    integer :: ifm, niv
    integer :: ieven
    character(len=24) :: errecn, errecv, erreni, erreno, erraac, errfct, errmsg
    integer :: jeecon, jeecov, jeeniv, jeenom, jeeact, jeefct, jeemsg
    character(len=24) :: errinf, errcvg, errevt
    integer :: jeinfo, jeconv, jeeevt
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... LECTURE GESTION ALGORITHME'
    endif
!
! --- GENERAL
!
    errinf = sderro(1:19)//'.INFO'
    call wkvect(errinf, 'V V I', 2, jeinfo)
    zi(jeinfo-1+1) = zeven
!
! --- OBJETS
!
    erreno = sderro(1:19)//'.ENOM'
    errecv = sderro(1:19)//'.ECOV'
    errecn = sderro(1:19)//'.ECON'
    erreni = sderro(1:19)//'.ENIV'
    errfct = sderro(1:19)//'.EFCT'
    erraac = sderro(1:19)//'.EACT'
    errcvg = sderro(1:19)//'.CONV'
    errevt = sderro(1:19)//'.EEVT'
    errmsg = sderro(1:19)//'.EMSG'
    call wkvect(erreno, 'V V K16', zeven, jeenom)
    call wkvect(errecv, 'V V I', zeven, jeecov)
    call wkvect(errecn, 'V V K8', zeven, jeecon)
    call wkvect(erreni, 'V V K16', zeven, jeeniv)
    call wkvect(errfct, 'V V K24', zeven, jeefct)
    call wkvect(erraac, 'V V I', zeven, jeeact)
    call wkvect(errcvg, 'V V I', 5, jeconv)
    call wkvect(errevt, 'V V I', 2, jeeevt)
    call wkvect(errmsg, 'V V K24', zeven, jeemsg)
!
    do ieven = 1, zeven
        zk16(jeenom-1+ieven) = neven(ieven)
        zk8 (jeecon-1+ieven) = ncret(ieven)
        zi (jeecov-1+ieven) = vcret(ieven)
        zk16(jeeniv-1+ieven) = teven(ieven)
        zk24(jeefct-1+ieven) = feven(ieven)
        zk24(jeemsg-1+ieven) = meven(ieven)
    end do
!
    call jedema()
end subroutine
